class ProjectDiscussion < ActiveRecord::Base
  attr_accessible :project_id, :subject, :message, :sticky
  
  belongs_to :dragoon
  belongs_to :project
  has_many :project_discussion_comments, :dependent => :destroy

  validates :subject, :presence => true, :length => { :in => 2..100 }
  validates :message, :presence => true
  validates :project, :presence => true
end
