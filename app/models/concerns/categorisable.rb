module Categorisable
  extend ActiveSupport::Concern
    
  included do
    belongs_to :category
    validates :category, presence: true
  end
end