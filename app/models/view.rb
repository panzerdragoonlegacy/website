class View < ActiveRecord::Base
  belongs_to :dragoon
  belongs_to :viewable, :polymorphic => true
end
