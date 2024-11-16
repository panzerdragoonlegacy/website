class Category < ApplicationRecord
  include Publishable
  include SluggableWithoutId
  include Syncable

  has_paper_trail

  has_many :categorisations,
           foreign_key: 'parent_id',
           dependent: :destroy,
           inverse_of: :parent
  accepts_nested_attributes_for(
    :categorisations,
    reject_if: :all_blank,
    allow_destroy: true
  )
  belongs_to :categorisation, foreign_key: 'id', optional: true
  has_many :subcategories,
           through: :categorisations,
           foreign_key: 'subcategory_id'

  has_many :pages, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :music_tracks, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :downloads, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true

  validates :description, presence: true, length: { in: 2..250 }
  validates :category_type, presence: true

  # The list of category types.
  CATEGORY_TYPES = %w[
    parent
    literature
    picture
    music_track
    video
    download
  ].freeze

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
    content_type: {
      content_type: 'image/jpeg'
    },
    size: {
      in: 0..5.megabytes
    }
  )

  before_save :set_published_at
  before_save :set_slug
  before_save :sync_file_name

  def sync_file_name
    if name.present?
      sync_file_name_of :category_picture, file_name: "#{slug_from_name}.jpg"
    end
  end

  def ordered_categorisations
    categorisations.order :sequence_number
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name publish category_type created_at updated_at published_at]
  end
end
