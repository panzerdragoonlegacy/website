class Discussion < ActiveRecord::Base
  acts_as_url :name, sync_url: true
  include Sluggable
  
  belongs_to :dragoon
  belongs_to :forum
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :views, :as => :viewable, :dependent => :destroy
  
  #scope :latest_comment_time, order("created_at ASC")
  
  #def latest_comment_time
  #  comments.last.created_at
  #end
  
=begin  
  after_create :latest_post_created_at
  
  # Adds the datetime of the discussion's latest post.
  def latest_post_created_at
    self.latest_post_created_at = self.created_at
    self.save
  end
=end
  
  validates :subject, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :message, :presence => true
  validates :forum, :presence => true
end
