module PicturesHelper
  
  def picture_tag(picture, style)
    image_file = Paperclip::Geometry.from_file(picture.picture.path(style))
    image_tag(picture.picture.url(style), 
      :alt => picture.name, 
      :width => image_file.width.to_i.to_s, 
      :height => image_file.height.to_i.to_s)
  end
  
end
