module VideosHelper
  def show_video_picture(video, style)
    img_tag_width = '0'
    img_tag_height = '0'
    video.send(
      'video_picture'
    ).options[:styles].each do |key, value|
      if key == style
        img_tag_width = value.split('x')[0]
        img_tag_height = value.split('x')[1].split('#')[0]
      end
    end
    if video.video_picture.present?
      image_file = Paperclip::Geometry.from_file(
        video.video_picture.path(style)
      )
      image_tag(
        video.video_picture.url(style),
        alt: video.name,
        width: image_file.width.to_i.to_s,
        height: image_file.height.to_i.to_s
      )
    else
      image_tag(
        'sorry-no-image-embedded.jpg',
        alt: video.name,
        width: img_tag_width,
        height: img_tag_height
      )
    end
  end
end
