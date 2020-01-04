module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def description(page_description)
    content_for(:description) { page_description }
  end

  def open_graph_type(open_graph_type)
    content_for(:open_graph_type) { open_graph_type }
  end

  def open_graph_image(open_graph_image)
    content_for(:open_graph_image) { open_graph_image }
  end

  def truncated_text(markdown_text, length = 250)
    html = markdown_to_html(markdown_text)

    require 'sanitize'
    html = Sanitize.fragment(html).strip

    truncate(html, length: length, separator: ' ')
  end

  def markdown_to_html(markdown_text)
    # Converts remaining Markdown syntax to html tags using Kramdown.
    require 'kramdown'
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
    require 'sanitize'
    html = Sanitize.clean(
      html,
      elements: allowed_elements,
      attributes: allowed_attributes,
      protocols: allowed_protocols
    )

    # Remove any footnote or footnote reference links.
    require 'nokogiri'
    html = Nokogiri::HTML.parse(html)
    html.css('a').each do |a|
      if (a.get_attribute('href') =~ /^#fn:/) or
        (a.get_attribute('href') =~ /^#fnref:/)
        # `Nokogiri::XML::Node#unlink` removes the node from the document
        a.unlink
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
