class Contribution < ActiveRecord::Base
  belongs_to :dragoon
  belongs_to :contributable, :polymorphic => true
end
