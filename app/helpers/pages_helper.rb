module PagesHelper
  def illustrated_markdown_to_html(page)
    # Automatically insert the table of contents before the first second level
    # Atx-style header.
    updated_markdown = ''
    contents_added = false
    page.content.each_line do |line|
      if line.start_with? '## ' and !contents_added
        line = "## Contents\n\n* replace this with toc\n{:toc}" + "\n\n" + line
        contents_added = true
      end
      updated_markdown += line
    end

    # Converts Markdown syntax to html tags using Kramdown.
    require 'kramdown'
    html = Kramdown::Document.new(updated_markdown, auto_ids: true).to_html

    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = %w[
      h2
      h3
      a
      img
      p
      ul
      ol
      li
      strong
      em
      cite
      blockquote
      code
      pre
      dl
      dt
      dd
      br
      hr
      sup
      div
    ]
    allowed_attributes = {
      'a' => %w[href rel rev class],
      'img' => %w[src alt],
      'sup' => ['id'],
      'div' => ['class'],
      'li' => ['id'],
      'h2' => ['id'],
      'h3' => ['id']
    }
    allowed_protocols = {
      'a' => {
        'href' => ['#fn', '#fnref', 'http', 'https', 'mailto', :relative]
      }
    }

    # Clean text of any unwanted html tags.
    require 'sanitize'
    html =
      Sanitize.clean(
        html,
        elements: allowed_elements,
        attributes: allowed_attributes,
        protocols: allowed_protocols
      )

    require 'nokogiri'
    html = Nokogiri::HTML.parse(html)

    # Remove the "Contents", "References", and "External Wikis" list items and
    # links from the table of contents.
    links_to_remove = %w[#contents #references #external-wikis]
    html
      .css('li')
      .each do |li|
        li
          .css('a')
          .each do |a|
            li.remove if a.get_attribute('href').in?(links_to_remove)
          end
      end

    # Remove the table of contents heading and list if the list is empty.
    html
      .css('ul')
      .each do |ul|
        li_count = 0
        ul.css('li').each { |li| li_count = li_count + 1 }
        if li_count == 0
          ul.remove
          html
            .css('h2')
            .each { |h2| h2.remove if h2.get_attribute('id') == 'contents' }
        end
      end

    # Replace paragraphs wrapping the images with divs.
    html.css('img').each { |img| img.parent.name = 'div' }

    # Sets correct src, width, and height attributes for the illustration.
    html
      .css('img')
      .each do |img|
        file_name = img.get_attribute('src')
        if illustration =
             Illustration.where(
               page_id: page.id,
               illustration_file_name: file_name
             ).first
          img.set_attribute('src', illustration.illustration.url(:embedded))
          image_file =
            Paperclip::Geometry.from_file(
              illustration.illustration.path(:embedded)
            )
          img.set_attribute('width', image_file.width.to_i.to_s)
          img.set_attribute('height', image_file.height.to_i.to_s)
        else
          img.set_attribute('src', '')
        end
      end

    # Alternate between aligning the divs left, right, or in a side by side
    # container.
    div_class = 'left'
    html
      .css('div')
      .each do |div|
        unless div.get_attribute('class') == 'footnotes'
          image_count = 0
          div.css('img').each { |img| image_count = image_count + 1 }
          if image_count == 2
            div.set_attribute('class', 'sidebyside')
          else
            if div_class == 'left'
              div.set_attribute('class', div_class)
              div_class = 'right'
            else
              div.set_attribute('class', div_class)
              div_class = 'left'
            end
          end
        end
      end

    # Align side by side images left and right by placing them inside divs.
    html
      .css('div.sidebyside')
      .each do |div|
        div.search('img').wrap('<div></div>')
        div_class = 'sidebysideleft'
        div
          .css('div')
          .each do |innerdiv|
            if div_class == 'sidebysideleft'
              innerdiv.set_attribute('class', div_class)
              div_class = 'sidebysideright'
            else
              innerdiv.set_attribute('class', div_class)
            end
          end
      end

    # Add image captions based on alternate text.
    html
      .css('img')
      .each do |img|
        caption = img.get_attribute('alt')
        img.add_next_sibling('<p>' + caption + '</p>')
      end

    # Converts nokogiri variable to html.
    html = html.to_html

    # Sanitize html of extra markup that Nokogiri adds.
    allowed_attributes['img'] +=
      %w[
        id
        width
        height
        data-popover-src
        data-popover-width
        data-popover-height
      ]
    html =
      Sanitize.clean(
        html,
        elements: allowed_elements,
        attributes: allowed_attributes,
        protocols: allowed_protocols
      )

    # Converts non-html links to html links.
    require 'rails_autolink'
    html = auto_link(html, sanitize: false)

    return html
  end
end
