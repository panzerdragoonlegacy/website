class Download < ActiveRecord::Base
  include Sluggable
  include Categorisable
  
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations
  
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :download, :presence => true
  
  validates_attachment_presence :download
  validates_attachment_size :download, :less_than => 100.megabytes
  validates_attachment_content_type :download, :content_type => ['application/zip']

  has_attached_file :download,
    :path => ":rails_root/public/system/:attachment/:id/:style/:download_filename",
    :url => "/system/:attachment/:id/:style/:download_filename"
  
  before_post_process :download_filename
  
  # Sets download filename in the database.
  def download_filename
    if self.download_content_type == 'application/zip'
      self.download_file_name = self.name.to_url + ".zip"
    end
  end
  
  # Sets download filename in the file system.
  Paperclip.interpolates :download_filename do |attachment, style|
    attachment.instance.download_filename
  end
end
