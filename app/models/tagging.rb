class Tagging < ActiveRecord::Base
  belongs_to :encyclopaedia_entry
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
