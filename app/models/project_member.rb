class ProjectMember < ActiveRecord::Base
  belongs_to :dragoon
  belongs_to :project
end
