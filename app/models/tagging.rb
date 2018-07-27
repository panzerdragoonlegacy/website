class Tagging < ActiveRecord::Base
  belongs_to :encyclopaedia_entry # Remove once migration has run in production.
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
