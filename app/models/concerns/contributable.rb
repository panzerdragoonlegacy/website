module Contributable
  extend ActiveSupport::Concern

  included do
    has_many :contributions, as: :contributable, dependent: :destroy
    has_many :contributor_profiles, through: :contributions
    validates :contributor_profiles,
              length: {
                minimum: 1,
                too_short: 'count must be at least %{count}'
              }
  end
end
