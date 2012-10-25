class PrivateDiscussionComment < ActiveRecord::Base
  belongs_to :private_discussion
  belongs_to :dragoon
end
