module NewsEntriesHelper
  
  def news_entry_markdown_to_html(markdown_text)
    require 'rails_autolink'
    require 'kramdown'
    require 'sanitize'
    require 'nokogiri'

    # Converts remaining Markdown syntax to html tags using Kramdown.
    html = Kramdown::Document.new(markdown_text, :auto_ids => false).to_html
    
    # Setup whitelist of html elements, attributes, and protocols that are allowed.
    allowed_elements = ['a', 'img', 'p', 'ul', 'ol', 'li', 'strong', 'em', 'cite', 
      'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br', 'div', 'video', 'source', 'audio']
    allowed_attributes = {'a' => ['href'], 'img' => ['src', 'alt'], 
      'video' => ['width', 'height', 'controls'],
      'audio' => ['controls'],
      'source' => ['type', 'src'],
      'div' => ['class']}
    allowed_protocols = {'a' => {'href' => ['http', 'https', 'mailto', :relative]}}
    
    # Clean text of any unwanted html tags.
    html = Sanitize.clean(html, :elements => allowed_elements, :attributes => allowed_attributes, 
      :protocols => allowed_protocols)
      
    html = Nokogiri::HTML.parse(html)      
    
    # Replace img tags with audio and video tags based on file extension.
    html.css('img').each do |tag|
      file_name = tag.get_attribute('src')
      
      # If file extension is that of an audio file.
      if file_name.split('.')[1] == 'mp3'
             
        # Replace surrounding paragraph with audio tag.
        tag.parent.name = 'audio'
        tag.parent.set_attribute('controls', 'controls')
        
        music_track_url = file_name.sub('.mp3', '')
        if music_track = MusicTrack.where(:url => music_track_url).first
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
        
        video_url = file_name.sub('.mp4', '')
        if video = Video.where(:url => video_url).first
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
    
    # Sets correct id, src, width, and height attributes for the picture mini thumbnail.
    html.css('img').each do |img|
      file_name = img.get_attribute('src')
      picture_url = file_name.sub('.jpg', '')
      if picture = Picture.where(:url => picture_url).first
        img.set_attribute('src', picture.picture.url(:mini_thumbnail))
        image_file = Paperclip::Geometry.from_file(picture.picture.path(:mini_thumbnail))
        img.set_attribute('width', image_file.width.to_i.to_s)
        img.set_attribute('height', image_file.height.to_i.to_s)
        img.set_attribute('alt', picture.name)
        
        # Sets the parent link's href attribute.
        img.parent.set_attribute('href', '/pictures/' + picture_url)
        
      else
        img.set_attribute('src', '')
      end
    end
      
    # Converts nokogiri variable to html.
    html = html.to_html    
    
    # Sanitize html of extra markup that Nokogiri adds.
    allowed_attributes['img'] += ['id', 'width', 'height']
    html = Sanitize.clean(html, :elements => allowed_elements, :attributes => allowed_attributes, 
      :protocols => allowed_protocols)  
    
    # Converts non-html links to html links.
    html = auto_link(html, :sanitize => false) 
    
    html = display_emoticons(html)
    
    return html
  end
  
end
