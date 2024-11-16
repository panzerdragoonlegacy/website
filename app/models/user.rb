class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :confirmable,
    :lockable,
    :timeoutable
  )

  has_paper_trail

  belongs_to :contributor_profile, optional: true

  def self.ransackable_attributes(auth_object = nil)
    %w[email administrator created_at updated_at confirmed_at locked_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[contributor_profile]
  end
end
