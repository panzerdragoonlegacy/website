class Picture < ActiveRecord::Base
  include Sluggable
  
  belongs_to :category
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations

  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :picture, :presence => true
  validates :category, :presence => true
  
  validates_attachment_presence :picture
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, :content_type => ['image/jpeg']

  has_attached_file :picture, 
    :styles => { :mini_thumbnail => "75x75#", :thumbnail => "150x150>", :triple_thumbnail => "150x150#",
      :double_thumbnail => "240x240#", :single_thumbnail => "486x486>", :embedded => "625x625>" }, 
    :path => ":rails_root/public/system/:attachment/:id/:style/:picture_filename",
    :url => "/system/:attachment/:id/:style/:picture_filename"

  before_post_process :picture_filename
  #after_post_process :update_picture_filename
  
  # Sets picture filename in the database when record is created.
  def picture_filename
    if self.picture_content_type == 'image/jpeg'
      self.picture_file_name = self.name.to_url + ".jpg"
    end
  end
  
  # Sets picture filename in the file system when record is created.
  Paperclip.interpolates :picture_filename do |attachment, style|
    attachment.instance.name.to_url + ".jpg"
  end
  
  #before_update :update_picture_filename
  
  # Updates picture filename in the database and file system when record is updated.
  #def update_picture_filename
    #new_file_name = self.name.to_url + ".jpg"
   # old_path = self.picture.path(:mini_thumbnail)
   # new_path = File.join(File.dirname(old_path), new_file_name)
   # FileUtils.move(old_path, new_path, :force => true)
   # self.picture_file_name = new_file_name
   # self.information = "old_path = " + old_path + " new_path = " + new_path + " picture_file_name = " + self.picture_file_name
  #end
  
end