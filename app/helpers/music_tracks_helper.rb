module MusicTracksHelper
  def show_music_track_picture(music_track, style)
    img_tag_width = '0'
    img_tag_height = '0'
    music_track.send(
      'music_track_picture'
    ).options[:styles].each do |key, value|
      if key == style
        img_tag_width = value.split('x')[0]
        img_tag_height = value.split('x')[1].split('#')[0]
      end
    end
    if music_track.music_track_picture.present?
      image_file = Paperclip::Geometry.from_file(
        music_track.music_track_picture.path(style)
      )
      image_tag(
        music_track.music_track_picture.url(style),
        alt: music_track.name,
        width: image_file.width.to_i.to_s,
        height: image_file.height.to_i.to_s
      )
    else
      image_tag(
        'sorry-no-image-embedded.jpg',
        alt: music_track.name,
        width: img_tag_width,
        height: img_tag_height
      )
    end
  end
end
