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
  CATEGORY_TYPES = %w(
    article
    download
    encyclopaedia_entry
    link music_track
    picture resource
    story
    video
  ).freeze

  before_validation :validate_category_type_reassignment
  before_validation :validate_presence_of_category_group
  before_validation :validate_category_and_category_group_type_match

  private

  def validate_category_type_reassignment
    if persisted?
      persisted_category = Category.find id
      if category_type != persisted_category.category_type &&
         send(persisted_category.category_type.pluralize).present?
        errors.add(persisted_category.category_type, 'category type cannot ' \
          'be reassigned while the category contains items.')
      end
    end
  end

  def validate_presence_of_category_group
    if category_is_groupable && category_group.blank?
      errors.add(category_type, 'categories must belong to a category group.')
    end
    if !category_is_groupable && category_group.present?
      errors.add(category_type, 'categories must not belong to a category ' \
        'group.')
    end
  end

  def validate_category_and_category_group_type_match
    if category_is_groupable && category_group.present?
      if category_group.category_group_type != category_type
        errors.add(category_type, 'categories must belong to a category ' \
          'group with a matching type.')
      end
    end
  end

  def category_is_groupable
    return false if category_type.blank?
    category_type.in?(CategoryGroup::CATEGORY_GROUP_TYPES)
  end
end
