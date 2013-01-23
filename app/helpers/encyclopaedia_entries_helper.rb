module EncyclopaediaEntriesHelper
  
  def encyclopaedia_entry_picture_tag(encyclopaedia_entry, style)
    image_file = Paperclip::Geometry.from_file(encyclopaedia_entry.encyclopaedia_entry_picture.path(style))
    image_tag(encyclopaedia_entry.encyclopaedia_entry_picture.url(style), 
      :alt => encyclopaedia_entry.name, 
      :width => image_file.width.to_i.to_s, 
      :height => image_file.height.to_i.to_s)
  end
  
end
