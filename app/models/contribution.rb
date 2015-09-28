class Contribution < ActiveRecord::Base
  belongs_to :contributor_profile
  belongs_to :contributable, polymorphic: true
end
