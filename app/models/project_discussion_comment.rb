class ProjectDiscussionComment < ActiveRecord::Base
  belongs_to :dragoon
  belongs_to :project_discussion
end
