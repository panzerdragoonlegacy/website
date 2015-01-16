module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def description(page_description)
    content_for(:description) { page_description }
  end

  def truncated_text(markdown_text)
    html = markdown_to_html(markdown_text)
    require 'sanitize'
    html = Sanitize.clean(html).strip
    html = truncate(html, length: 250, separator: ' ')
    return html
  end

  def display_dragoons(dragoons)
    dragoons.each do |dragoon|
      link_to(dragoon.name, dragoon)
    end
  end

  def display_emoticons(text)
    emoticons = Emoticon.all
    emoticons.each do |emoticon|
  	  text.gsub!(emoticon.code, image_tag(emoticon.emoticon.url))
    end
    return text
  end

  def markdown_to_html(markdown_text)
    require 'rails_autolink'
    require 'kramdown'
    require 'sanitize'

    # Converts remaining Markdown syntax to html tags using Kramdown.
    html = Kramdown::Document.new(markdown_text, auto_ids: false).to_html

    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = ['a', 'p', 'ul', 'ol', 'li', 'strong', 'em', 'cite',
      'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br']
    allowed_attributes = {
      'a' => ['href'],
      'img' => ['src', 'alt']
    }
    allowed_protocols = {
      'a' => {
        'href' => ['http', 'https', 'mailto', :relative]
      }
    }

    # Clean text of any unwanted html tags.
    html = Sanitize.clean(
      html,
      elements: allowed_elements,
      attributes: allowed_attributes,
      protocols: allowed_protocols
    )

    # Converts non-html links to html links.
    html = auto_link(html, sanitize: false)

    html = display_emoticons(html)

    return html
  end

  def illustrated_markdown_to_html(id, type, markdown_text)
    require 'rails_autolink'
    require 'kramdown'
    require 'sanitize'
    require 'nokogiri'

    # Todo: automatically insert table of contents

    # Converts Markdown syntax to html tags using Kramdown.
    html = Kramdown::Document.new(markdown_text, auto_ids: true).to_html

    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = ['h2', 'h3', 'a', 'img', 'p', 'ul', 'ol', 'li', 'strong',
      'em', 'cite', 'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br', 'hr',
      'sup', 'div']
    allowed_attributes = {
      'a' => ['href', 'rel', 'rev', 'class'],
      'img' => ['src', 'alt'],
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
    html = Sanitize.clean(
      html,
      elements: allowed_elements,
      attributes: allowed_attributes,
      protocols: allowed_protocols
    )

    html = Nokogiri::HTML.parse(html)

    # Replace paragraphs wrapping the images with divs.
    html.css('img').each do |img|
      img.parent.name = 'div'
    end

    # Sets correct src, width, and height attributes for the illustration.
    html.css('img').each do |img|
      file_name = img.get_attribute('src')
      if illustration = Illustration.where(illustratable_id: id,
        illustratable_type: type, illustration_file_name: file_name).first
        img.set_attribute('src', illustration.illustration.url(:embedded))
        image_file = Paperclip::Geometry.from_file(
          illustration.illustration.path(:embedded))
        img.set_attribute('width', image_file.width.to_i.to_s)
        img.set_attribute('height', image_file.height.to_i.to_s)
        img.set_attribute('data-popover-src', illustration.illustration.url(
          :popover))
        popover_image_file = Paperclip::Geometry.from_file(
          illustration.illustration.path(:popover))
        img.set_attribute('data-popover-width',
          popover_image_file.width.to_i.to_s)
        img.set_attribute('data-popover-height',
          popover_image_file.height.to_i.to_s)
      else
        img.set_attribute('src', '')
      end
    end

    # Alternate between aligning the divs left, right, or in a side by side
    # container.
    div_class = 'left'
    html.css('div').each do |div|
      unless div.get_attribute('class') == 'footnotes'
        image_count = 0
        div.css('img').each do |img|
          image_count = image_count + 1
        end
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
    html.css('div.sidebyside').each do |div|
      div.search("img").wrap('<div></div>')
      div_class = 'sidebysideleft'
      div.css('div').each do |innerdiv|
        if div_class == 'sidebysideleft'
          innerdiv.set_attribute('class', div_class)
          div_class = 'sidebysideright'
        else
          innerdiv.set_attribute('class', div_class)
        end
      end
    end

    # Add image captions based on alternate text.
    html.css('img').each do |img|
      caption = img.get_attribute('alt')
      img.add_next_sibling('<p>' + caption + '</p>')
    end

    # Wrap each illustration with a popover link.
    html.css('div').each do |div|
      div.search("img").wrap('<a href="#" class="popover"></a>')
    end

    # Converts nokogiri variable to html.
    html = html.to_html

    # Sanitize html of extra markup that Nokogiri adds.
    allowed_attributes['img'] += ['id', 'width', 'height', 'data-popover-src',
      'data-popover-width', 'data-popover-height']
    html = Sanitize.clean(
      html,
      elements: allowed_elements,
      attributes: allowed_attributes,
      protocols: allowed_protocols
    )

    # Converts non-html links to html links.
    html = auto_link(html, sanitize: false)

    html = display_emoticons(html)

    return html
  end
end
