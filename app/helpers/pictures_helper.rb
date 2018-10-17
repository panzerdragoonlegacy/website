module PicturesHelper
  def show_picture(record, attachment_name, style)
    img_tag_width = '0'
    img_tag_height = '0'
    record.send(attachment_name).options[:styles].each do |key, value|
      if key == style
        img_tag_width = value.split('x')[0]
        img_tag_height = value.split('x')[1].split('#')[0]
      end
    end
    if record.send(attachment_name).file?
      image_file = Paperclip::Geometry.from_file(
        record.send(attachment_name).path(style)
      )
      image_tag(
        record.send(attachment_name).url(style),
        alt: record.name,
        width: image_file.width.to_i.to_s,
        height: image_file.height.to_i.to_s
      )
    else
      image_tag(
        'sorry-no-image-embedded.jpg',
        alt: record.name,
        width: img_tag_width,
        height: img_tag_height
      )
    end
  end
end
