module NewsEntriesHelper
  def news_entry_markdown_to_html(markdown_text)
    require 'rails_autolink'
    require 'kramdown'
    require 'sanitize'
    require 'nokogiri'

    # Converts remaining Markdown syntax to html tags using Kramdown.
    html = Kramdown::Document.new(markdown_text, auto_ids: false).to_html

    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = %w[
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
      div
      iframe
      video
      source
      audio
    ]
    allowed_attributes = {
      'a' => ['href'],
      'img' => %w[src alt],
      'iframe' => %w[width height src frameborder allowfullscreen],
      'video' => %w[width height controls poster],
      'audio' => ['controls'],
      'source' => %w[type src],
      'div' => ['class']
    }
    allowed_protocols = {
      'a' => {
        'href' => ['http', 'https', 'mailto', :relative]
      }
    }

    # Clean text of any unwanted html tags.
    html =
      Sanitize.clean(
        html,
        elements: allowed_elements,
        attributes: allowed_attributes,
        protocols: allowed_protocols
      )

    html = Nokogiri::HTML.parse(html)

    # Replace img tags with audio and video tags based on file extension.
    html
      .css('img')
      .each do |tag|
        file_name = tag.get_attribute('src')

        # If file extension is that of an audio file.
        if file_name.split('.')[1] == 'mp3'
          # Replace surrounding paragraph with audio tag.
          tag.parent.name = 'audio'
          tag.parent.set_attribute('controls', 'controls')

          music_track_id = file_name.split('-')[0].to_i
          if music_track = MusicTrack.where(id: music_track_id).first
            mp3_source_tag = html.create_element('source')
            p_tag = html.create_element('p')

            # Replace img tag with source tags.
            tag.replace(mp3_source_tag)
            mp3_source_tag['type'] = 'audio/mp3'
            mp3_source_tag['src'] = music_track.mp3_music_track.url
            mp3_source_tag.add_next_sibling(p_tag)
            p_tag.content = 'Your browser does not support the audio element.'

            # Add view details link below embedded audio.
            p_tag = html.create_element('p')
            a_tag = html.create_element('a')
            a_tag.set_attribute('href', music_track_path(music_track))
            a_tag.content = 'Audio Details for "' + music_track.name + '"'
            p_tag.add_child(a_tag)
            mp3_source_tag.parent.add_next_sibling(p_tag)
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
            tag.parent.set_attribute(
              'poster',
              video.video_picture.url(:embedded)
            )
            mp4_source_tag = html.create_element('source')
            p_tag = html.create_element('p')

            # Replace img tag with source tags.
            tag.replace(mp4_source_tag)
            mp4_source_tag['type'] = 'video/mp4'
            mp4_source_tag['src'] = video.mp4_video.url
            mp4_source_tag.add_next_sibling(p_tag)
            p_tag.content = 'Your browser does not support the video element.'

            # Add view details link below embedded video.
            p_tag = html.create_element('p')
            a_tag = html.create_element('a')
            a_tag.set_attribute('href', video_path(video))
            a_tag.content = 'Video Details for "' + video.name + '"'
            p_tag.add_child(a_tag)
            mp4_source_tag.parent.add_next_sibling(p_tag)
          end
        end
      end

    # Replace paragraphs wrapping the images with divs.
    html.css('img').each { |img| img.parent.name = 'div' }

    # Wrap picture with a link.
    html.css('div').each { |div| div.search('img').wrap('<a></a>') }

    # Finds out how many images are in the news entry.
    img_count = 0
    html.css('img').each { |img| img_count = img_count + 1 }

    # Sets correct id, src, width, and height attributes for the picture's
    # thumbnails.
    html
      .css('img')
      .each do |img|
        file_name = img.get_attribute('src')
        picture_id = file_name.split('-')[0].to_i
        picture = Picture.find(picture_id) unless picture_id == 0
        if picture
          if img_count == 1
            img.set_attribute('src', picture.picture.url(:single_thumbnail))
            image_file =
              Paperclip::Geometry.from_file(
                picture.picture.path(:single_thumbnail)
              )
          elsif img_count == 2
            img.set_attribute('src', picture.picture.url(:double_thumbnail))
            image_file =
              Paperclip::Geometry.from_file(
                picture.picture.path(:double_thumbnail)
              )
          elsif img_count == 3
            img.set_attribute('src', picture.picture.url(:triple_thumbnail))
            image_file =
              Paperclip::Geometry.from_file(
                picture.picture.path(:triple_thumbnail)
              )
          else
            img.set_attribute('src', picture.picture.url(:news_entry_thumbnail))
            image_file =
              Paperclip::Geometry.from_file(
                picture.picture.path(:news_entry_thumbnail)
              )
          end
          img.set_attribute('width', image_file.width.to_i.to_s)
          img.set_attribute('height', image_file.height.to_i.to_s)
          img.set_attribute('alt', picture.name)

          # Sets the parent link's href attribute.
          img.parent.set_attribute(
            'href',
            "/pictures/#{picture.id.to_s}-#{picture.url}"
          )
        else
          img.set_attribute('src', '')
        end
      end

    # Convert links to embedded oneboxes
    require 'onebox'
    html
      .css('p')
      .each do |tag|
        url = tag.content
        next unless (url =~ %r{http:\/\/(.)}) || (url =~ %r{https:\/\/(.)})
        begin
          preview = Onebox.preview(url)
          new_node = html.create_element 'div'
          new_node['class'] = 'onebox'
          new_node.inner_html = preview.to_s
        rescue StandardError
          new_node = html.create_element 'a'
          new_node.set_attribute 'href', url
          new_node.inner_html = url
        end
        tag.replace new_node
      end

    # Converts nokogiri variable to html.
    html = html.to_html

    # Sanitize html of extra markup that Nokogiri adds.
    allowed_attributes['img'] += %w[id width height]
    html =
      Sanitize.clean(
        html,
        elements: allowed_elements,
        attributes: allowed_attributes,
        protocols: allowed_protocols
      )

    # Converts non-html links to html links.
    html = auto_link(html, sanitize: false)

    return html
  end
end
