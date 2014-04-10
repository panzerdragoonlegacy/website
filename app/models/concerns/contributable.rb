module Contributable
  extend ActiveSupport::Concern
    
  included do
    has_many :contributions, as: :contributable, dependent: :destroy
    has_many :dragoons, through: :contributions
    validates :dragoons, length: { minimum: 1 }
  end
end
