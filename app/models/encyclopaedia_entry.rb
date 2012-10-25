class EncyclopaediaEntry < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url
  end
  
  belongs_to :category
  has_many :illustrations, :as => :illustratable, :dependent => :destroy
  accepts_nested_attributes_for :illustrations, :reject_if => lambda { |a| a[:illustration].blank? }, 
    :allow_destroy => true
  
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :encyclopaedia_entry_picture, :presence => true
  validates :information, :presence => true  
  validates :content, :presence => true
  validates :category, :presence => true
  
  validates_attachment_size :encyclopaedia_entry_picture, :less_than => 5.megabytes
  validates_attachment_content_type :encyclopaedia_entry_picture, :content_type => ['image/jpeg']

  has_attached_file :encyclopaedia_entry_picture, :styles => { :thumbnail => "150x150", :embedded => "280x280>" }, 
    :path => ":rails_root/public/system/:attachment/:id/:style/:encyclopaedia_entry_picture_filename",
    :url => "/system/:attachment/:id/:style/:encyclopaedia_entry_picture_filename"
  
  before_post_process :encyclopaedia_entry_picture_filename
  
  # Sets encyclopaedia_entry_picture filename in the database.
  def encyclopaedia_entry_picture_filename
    if self.encyclopaedia_entry_picture_content_type == 'image/jpeg'
      self.encyclopaedia_entry_picture_file_name = self.name.to_url + ".jpg"
    end
  end
  
  # Sets encyclopaedia_entry_picture filename in the file system.
  Paperclip.interpolates :encyclopaedia_entry_picture_filename do |attachment, style|
    attachment.instance.encyclopaedia_entry_picture_filename
  end
end
