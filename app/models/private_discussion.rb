class PrivateDiscussion < ActiveRecord::Base  
  belongs_to :dragoon
  has_many :private_discussion_comments, :dependent => :destroy
  has_many :private_discussion_members, :dependent => :destroy
  has_many :dragoons, :through => :private_discussion_members

  validates :subject, :presence => true, :length => { :in => 2..100 }
  validates :message, :presence => true
end
