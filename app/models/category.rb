class Category < ApplicationRecord
  include Publishable
  include SluggableWithoutId
  include Syncable

  has_paper_trail

  belongs_to :category_group
  belongs_to :saga, optional: true
  has_many :news_entries, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :music_tracks, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :downloads, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :short_name_for_saga, length: { in: 0..50 }
  validates :short_name_for_media_type, length: { in: 0..50 }
  validates :description, presence: true, length: { in: 2..250 }
  validates :category_type, presence: true

  # The list of category types.
  CATEGORY_TYPES = %w(
    news_entry
    encyclopaedia
    literature
    picture
    music_track
    video
    download
  ).freeze

  has_attached_file(
    :category_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      embedded: '622x250#'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :category_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_validation :validate_presence_of_category_group
  # Commented out so that reassignment migration can run without issues.
  # before_validation :validate_category_and_category_group_type_match

  before_save :set_published_at
  before_save :sync_file_name

  def sync_file_name
    if name.present?
      sync_file_name_of :category_picture, file_name: "#{name.to_url}.jpg"
    end
  end

  private

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
