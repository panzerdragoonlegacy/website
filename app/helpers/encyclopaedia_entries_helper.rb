module EncyclopaediaEntriesHelper
  def show_encyclopaedia_entry_picture(encyclopaedia_entry, style)
    img_tag_width = '0'
    img_tag_height = '0'
    encyclopaedia_entry.send(
      'encyclopaedia_entry_picture'
    ).options[:styles].each do |key, value|
      if key == style
        img_tag_width = value.split('x')[0]
        img_tag_height = value.split('x')[1].split('#')[0]
      end
    end
    if encyclopaedia_entry.encyclopaedia_entry_picture.present?
      image_file = Paperclip::Geometry.from_file(
        encyclopaedia_entry.encyclopaedia_entry_picture.path(style)
      )
      image_tag(
        encyclopaedia_entry.encyclopaedia_entry_picture.url(style),
        alt: encyclopaedia_entry.name,
        width: image_file.width.to_i.to_s,
        height: image_file.height.to_i.to_s
      )
    else
      image_tag(
        'sorry-no-image-embedded.jpg',
        alt: encyclopaedia_entry.name,
        width: img_tag_width,
        height: img_tag_height
      )
    end
  end
end
