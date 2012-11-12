class Relation < ActiveRecord::Base
  belongs_to :encyclopaedia_entry
  belongs_to :relatable, :polymorphic => true
end
