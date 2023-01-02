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

    # Setup allow list of html elements, attributes, and protocols.
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

    # Remove the "Contents" and "References" list items and links from the
    # table of contents.
    links_to_remove = %w[#contents #references]
    html
      .css('li')
      .each do |li|
        li
          .css('a')
          .each do |a|
            li.remove if a.get_attribute('href').in?(links_to_remove)
          end
      end

    # Remove the table of contents heading and list contains only 1 or no items.
    html
      .css('ul')
      .each do |ul|
        li_count = 0
        ul.css('li').each { |li| li_count = li_count + 1 }
        if li_count <= 1
          ul.remove
          html
            .css('h2')
            .each { |h2| h2.remove if h2.get_attribute('id') == 'contents' }
        end
      end

    # Sets correct src, srcset, and class attributes for each illustration.
    html
      .css('img')
      .each do |img|
        file_name = img.get_attribute('src')
        if illustration =
             Illustration.where(
               page_id: page.id,
               illustration_file_name: file_name
             ).first
          original_image_file =
            Paperclip::Geometry.from_file(
              illustration.illustration.path(:original)
            )
          legacy_url = illustration.illustration.url(:original)

          # Use "modern" image sizes only if the image exceeds 768 pixels wide.
          # The "legacy" images were mostly captured in the early 2000s at 280
          # pixels or smaller and don't look good upscaled to a higher
          # resolutions, so they are displayed at half the tablet layout width.
          if original_image_file.width.to_i > 768
            modern_url = illustration.illustration.url(:original)
            img.set_attribute(
              'srcset',
              "#{legacy_url} 320w, #{modern_url} 768w"
            )
            img.set_attribute('sizes', '(max-width: 320px) 320px, 768px')
            img.set_attribute('src', modern_url)
            img.set_attribute('class', 'illustration__image--modern')
            img.parent.set_attribute(
              'class',
              'illustration illustration--modern'
            )
          else
            img.set_attribute('src', legacy_url)
            img.append_class('illustration__image--legacy')
            img.parent.set_attribute(
              'class',
              'illustration illustration--legacy'
            )
          end
        else
          img.set_attribute('src', '')
          img.append_class('illustration__image--missing')
        end
      end

    # Replace the paragraphs wrapping the illustration images with figures:
    html.css('img').each { |img| img.parent.name = 'figure' }

    # Add figure captions extracted from the image alt text:
    alignment = 'left'
    html
      .css('figure')
      .each do |figure|
        captions = []
        image_class = ''
        figure
          .css('img')
          .each do |img|
            captions << img.get_attribute('alt')
            image_class = img.get_attribute('class')
          end
        if captions.count < 1
          figure.add_child(
            '<figcaption class="illustration__caption--image-missing">' +
              'Missing image' + '</figcaption>'
          )
        elsif captions.count == 1
          figure.append_class('illustration--single-image')
          if image_class == 'illustration__image--legacy'
            # For individual legacy images, alternate between aligning the
            # figure to the left or the right of the text.
            figure.append_class('illustration--' + alignment)
            alignment == 'left' ? alignment = 'right' : alignment = 'left'
          end
          figure.add_child(
            '<figcaption class="illustration__caption--single-image">' +
              captions[0] + '</figcaption>'
          )
        elsif captions.count == 2
          figure.append_class('illustration--double-image')
          figure.add_child(
            '<figcaption class="illustration__caption--double-image">' +
              '<span class="caption-alignment--top">Top</span>' +
              '<span class="caption-alignment--left">Left</span>' +
              captions[0] +
              '<span class="caption-alignment--bottom">Bottom</span>' +
              '<span class="caption-alignment--right">Right</span>' +
              captions[1] + '</figcaption>'
          )
        elsif captions.count > 2
          figure.add_child(
            '<figcaption class="illustration__caption--images-exceeded">' +
              'Limit of 2 images per figure exceeded.' + '</figcaption>'
          )
        end
      end

    # Converts nokogiri variable to html.
    html = html.to_html

    # Converts non-html links to html links.
    require 'rails_autolink'
    html = auto_link(html, sanitize: false)

    return html
  end
end
