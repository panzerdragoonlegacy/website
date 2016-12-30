module NewsEntriesHelper
  def show_news_entry_picture(news_entry, style)
    img_tag_width = '0'
    img_tag_height = '0'
    news_entry.send(
      'news_entry_picture'
    ).options[:styles].each do |key, value|
      if key == style
        img_tag_width = value.split('x')[0]
        img_tag_height = value.split('x')[1].split('#')[0]
      end
    end
    if news_entry.news_entry_picture.present?
      image_file = Paperclip::Geometry.from_file(
        news_entry.news_entry_picture.path(style)
      )
      image_tag(
        news_entry.news_entry_picture.url(style),
        alt: news_entry.name,
        width: image_file.width.to_i.to_s,
        height: image_file.height.to_i.to_s
      )
    end
  end

  def news_entry_markdown_to_html(markdown_text)
    require 'rails_autolink'
    require 'kramdown'
    require 'sanitize'
    require 'nokogiri'

    # Converts remaining Markdown syntax to html tags using Kramdown.
    html = Kramdown::Document.new(markdown_text, auto_ids: false).to_html

    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = ['a', 'img', 'p', 'ul', 'ol', 'li', 'strong', 'em',
      'cite', 'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br', 'div',
      'iframe', 'video', 'source', 'audio']
    allowed_attributes = {
      'a' => ['href'],
      'img' => ['src', 'alt'],
      'iframe' => ['width', 'height', 'src', 'frameborder', 'allowfullscreen'],
      'video' => ['width', 'height', 'controls'],
      'audio' => ['controls'],
      'source' => ['type', 'src'],
      'div' => ['class']
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

    html = Nokogiri::HTML.parse(html)

    # Replace img tags with audio and video tags based on file extension.
    html.css('img').each do |tag|
      file_name = tag.get_attribute('src')

      # If file extension is that of an audio file.
      if file_name.split('.')[1] == 'mp3'

        # Replace surrounding paragraph with audio tag.
        tag.parent.name = 'audio'
        tag.parent.set_attribute('controls', 'controls')

        music_track_id = file_name.split('-')[0].to_i
        if music_track = MusicTrack.where(id: music_track_id).first
          mp3_source_tag = html.create_element('source')
          ogg_source_tag = html.create_element('source')
          p_tag = html.create_element('p')

          # Replace img tag with source tags.
          tag.replace(mp3_source_tag)
          mp3_source_tag['type'] = 'audio/mp3'
          mp3_source_tag['src'] = music_track.mp3_music_track.url
          mp3_source_tag.add_next_sibling(ogg_source_tag)
          ogg_source_tag['type'] = 'audio/ogg'
          ogg_source_tag['src'] = music_track.ogg_music_track.url
          ogg_source_tag.add_next_sibling(p_tag)
          p_tag.content = 'Your browser does not support the audio element.'
        end
      end

      # If file extension is that of a video file.
      if file_name.split('.')[1] == 'mp4'

        # Replace surrounding paragraph with video tag.
        tag.parent.name = 'video'
        tag.parent.set_attribute('width', '486')
        tag.parent.set_attribute('controls', 'controls')

        video_id = file_name.split('-')[0].to_i
        if video = Video.where(id: video_id).first
          mp4_source_tag = html.create_element('source')
          webm_source_tag = html.create_element('source')
          p_tag = html.create_element('p')

          # Replace img tag with source tags.
          tag.replace(mp4_source_tag)
          mp4_source_tag['type'] = 'video/mp4'
          mp4_source_tag['src'] = video.mp4_video.url
          mp4_source_tag.add_next_sibling(webm_source_tag)
          webm_source_tag['type'] = 'video/webm'
          webm_source_tag['src'] = video.webm_video.url
          webm_source_tag.add_next_sibling(p_tag)
          p_tag.content = 'Your browser does not support the video element.'
        end
      end
    end

    # Replace paragraphs wrapping the images with divs.
    html.css('img').each do |img|
      img.parent.name = 'div'
    end

    # Wrap picture with a link.
    html.css('div').each do |div|
      div.search("img").wrap('<a></a>')
    end

    # Finds out how many images are in the news entry.
    img_count = 0
    html.css('img').each do |img|
      img_count = img_count + 1
    end

    # Sets correct id, src, width, and height attributes for the picture's
    # thumbnails.
    html.css('img').each do |img|
      file_name = img.get_attribute('src')
      picture_id = file_name.split('-')[0].to_i
      picture = Picture.find(picture_id) unless picture_id == 0
      if picture
        if img_count == 1
          img.set_attribute('src', picture.picture.url(:single_thumbnail))
          image_file = Paperclip::Geometry.from_file(picture.picture.path(
            :single_thumbnail))
        elsif img_count == 2
          img.set_attribute('src', picture.picture.url(:double_thumbnail))
          image_file = Paperclip::Geometry.from_file(picture.picture.path(
            :double_thumbnail))
        elsif img_count == 3
          img.set_attribute('src', picture.picture.url(:triple_thumbnail))
          image_file = Paperclip::Geometry.from_file(picture.picture.path(
            :triple_thumbnail))
        else
          img.set_attribute('src', picture.picture.url(:news_entry_thumbnail))
          image_file = Paperclip::Geometry.from_file(picture.picture.path(
            :news_entry_thumbnail))
        end
        img.set_attribute('width', image_file.width.to_i.to_s)
        img.set_attribute('height', image_file.height.to_i.to_s)
        img.set_attribute('alt', picture.name)

        # Sets the parent link's href attribute.
        img.parent.set_attribute(
          'href', "/pictures/#{picture.id.to_s}-#{picture.url}"
        )

      else
        img.set_attribute('src', '')
      end
    end

    # Convert paragraphs to embedded YouTube videos if they contain links to
    # YouTube videos:
    html.css('p').each do |tag|
      link = tag.content
      if (link =~ /(.):\/\/www.youtube.com\/embed\/(.)/) or
        (link =~ /(.):\/\/www.youtube.com\/watch\?v=(.)/) or
        (link =~ /(.):\/\/youtu.be\/(.)/)

        # Get video ID which comes after the last ?v= or / in the URL:
        if link =~ /(.)watch\?v=(.)/
          video_id = link.split('?v=')[-1]
        else
          video_id = link.split('/')[-1]
        end

        # Replace surrounding paragraph with YouTube iframe:
        tag.name = 'iframe'
        tag.set_attribute('width', '486')
        tag.set_attribute('height', '320')
        tag.set_attribute('src', 'https://www.youtube.com/embed/' + video_id)
        tag.set_attribute('frameborder', '0')
        tag.set_attribute('allowfullscreen', '')
      end
    end

    # Converts nokogiri variable to html.
    html = html.to_html

    # Sanitize html of extra markup that Nokogiri adds.
    allowed_attributes['img'] += ['id', 'width', 'height']
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
