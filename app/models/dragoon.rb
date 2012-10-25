class Dragoon < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end
  
  attr_accessor :password

  attr_accessible :name, :email_address, :password, :password_confirmation, :time_zone, :role, 
    :avatar, :birthday, :gender, :country, :information, :favourite_quotations, :occupation, :interests, :website,
    :facebook_username, :twitter_username, :xbox_live_gamertag, :playstation_network_online_id, :wii_number,
    :steam_username, :windows_live_id, :yahoo_id, :aim_screenname, :icq_number, :jabber_id, :skype_name
  
  before_save :encrypt_password
  before_create :set_default_administrator

  has_many :discussions, :dependent => :destroy
  has_many :commments, :dependent => :destroy
  has_many :news_entries, :dependent => :destroy
  has_many :private_discussions, :dependent => :destroy
  has_many :private_discussion_comments, :dependent => :destroy
  has_many :project_discussions, :dependent => :destroy
  has_many :project_comments, :dependent => :destroy
  has_many :views, :dependent => :destroy
  
  has_many :contributions, :dependent => :destroy
  has_many :articles, :through => :contributions
  has_many :downloads, :through => :contributions
  has_many :links, :through => :contributions
  has_many :music_tracks, :through => :contributions
  has_many :pictures, :through => :contributions
  has_many :poems, :through => :contributions
  has_many :quizzes, :through => :contributions
  has_many :resources, :through => :contributions
  has_many :stories, :through => :contributions
  has_many :videos, :through => :contributions
  
  has_many :private_discussion_members, :dependent => :destroy
  has_many :private_discussions, :through => :private_discussion_members
  
  has_many :project_members, :dependent => :destroy
  has_many :projects, :through => :project_members  


#  validates_confirmation_of :password
#  validates_presence_of :password, :on => :create
  
  validates :name, :presence => true, :length => { :in => 2..50 }, :uniqueness => true
  validates :email_address, :presence => true, :length => { :in => 2..50 }, :uniqueness => true
  validates :password, :presence => true, :on => :create
  validates :password, :confirmation => true
  
  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg']

  has_attached_file :avatar, :styles => { :thumbnail => "75x75#", :embedded => "280x280>" }, 
    :path => ":rails_root/public/system/:attachment/:id/:style/:avatar_filename",
    :url => "/system/:attachment/:id/:style/:avatar_filename"
  
  before_post_process :avatar_filename
  
  # Sets avatar filename in the database.
  def avatar_filename
    if self.avatar_content_type == 'image/jpeg'
      self.avatar_file_name = "avatar.jpg"
    end
  end
  
  # Sets avatar filename in the file system.
  Paperclip.interpolates :avatar_filename do |attachment, style|
    attachment.instance.avatar_filename
  end

  GENDERS = %w[female male other]
  ROLES = %w[administrator registered suspended guest]
  
  # Returns true if dragoon belongs to the specified role.
  def role?(role)
    self.role == role.to_s ? true : false
  end
  
  # Sets default administrator if he/she is the first user.
  def set_default_administrator
    Dragoon.count < 1 ? self.role = :administrator.to_s : self.role = :registered.to_s
  end

  def create_perishable_token
    self.perishable_token_expiry = 1.day.from_now
    self.perishable_token = rand(10 ** 100).to_s
    self.save #(:validate => false)
  end
  
  def create_remember_token
    self.remember_token = rand(10 ** 100).to_s
    self.save
  end
  
  def self.authenticate_with_remember_token(id, cookie_remember_token)
    dragoon = find_by_id(id)
    (dragoon && dragoon.remember_token == cookie_remember_token) ? dragoon : nil
  end
    
  def self.dragoon_exists?(name_or_email_address)
    dragoon = find_by_name(name_or_email_address) || dragoon = find_by_email_address(name_or_email_address)
  end

  def self.authenticate(name_or_email_address, password)
    dragoon = dragoon_exists?(name_or_email_address)
    (dragoon && BCrypt::Password.new(dragoon.password_digest) == password) ? dragoon : nil
  end

  def encrypt_password
    if password.present?
      self.password_digest = BCrypt::Password.create(password)
    end
  end
  
end