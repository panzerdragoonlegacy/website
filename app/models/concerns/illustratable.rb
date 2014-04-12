module Illustratable

  extend ActiveSupport::Concern
    
  included do
    has_many :illustrations, as: :illustratable, dependent: :destroy
    accepts_nested_attributes_for :illustrations, reject_if: :all_blank, allow_destroy: true
  end
  
end
