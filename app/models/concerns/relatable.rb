module Relatable
  extend ActiveSupport::Concern

  included do
    has_many :relations, as: :relatable, dependent: :destroy
    has_many :encyclopaedia_entries, through: :relations
  end
end
