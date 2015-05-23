class Category < ActiveRecord::Base
  include Sluggable

  belongs_to :category_group
  has_many :articles, dependent: :destroy
  has_many :downloads, dependent: :destroy
  has_many :encyclopaedia_entries, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :music_tracks, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :resources, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :videos, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }
  validates :category_type, presence: true

  # The list of category types.
  CATEGORY_TYPES = %w[article download encyclopaedia_entry link music_track
    picture resource story video]

  before_validation :validate_presence_of_category_group
  before_validation :validate_category_and_category_group_type_match

  private

  def validate_presence_of_category_group
    if self.category_type.in?(CategoryGroup::CATEGORY_GROUP_TYPES)
      if self.category_group.blank?
        self.errors.add(category_type, 'categories must belong to a ' +
          'category group.')
      end
    else
      if self.category_group.present?
        self.errors.add(category_type, 'categories must not belong to a ' +
          'category group.')
      end
    end
  end

  def validate_category_and_category_group_type_match
    if self.category_type.in?(CategoryGroup::CATEGORY_GROUP_TYPES)
      if self.category_group.present? and self.category_type.present?
        if self.category_group.category_group_type != self.category_type
          self.errors.add(category_type, 'categories must belong to a ' +
            'category group with a matching category type/category group type.')
        end
      end
    end
  end
end
