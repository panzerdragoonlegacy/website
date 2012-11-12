class Picture < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param
    url
  end
  
  belongs_to :category
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions

  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :picture, :presence => true
  validates :category, :presence => true  
  
  validates_attachment_presence :picture
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, :content_type => ['image/jpeg']

  has_attached_file :picture, 
    :styles => { :mini_thumbnail => "75x75#", :thumbnail => "150x150>", :embedded => "625x625>" }, 
    :path => ":rails_root/public/system/:attachment/:id/:style/:picture_filename",
    :url => "/system/:attachment/:id/:style/:picture_filename"
  
  before_post_process :picture_filename
  
  # Sets picture filename in the database.
  def picture_filename
    if self.picture_content_type == 'image/jpeg'
      self.picture_file_name = self.name.to_url + ".jpg"
    end
  end
  
  # Sets picture filename in the file system.
  Paperclip.interpolates :picture_filename do |attachment, style|
    attachment.instance.picture_filename
  end
end