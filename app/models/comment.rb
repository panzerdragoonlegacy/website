class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :dragoon
  has_many :views, :as => :viewable, :dependent => :destroy
  
=begin
  after_create :latest_post_created_at
  
  # Set the datetime of the discussion's latest post.
  def latest_post_created_at
    if self.commentable_type = 'Discussion'
      discussion = Discussion.where(:id => self.commentable_id)
      discussion.latest_post_created_at = self.created_at
      discussion.save
    end
  end  
=end
  
  validates :message, :presence => true  
end
