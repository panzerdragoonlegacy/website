class Page < ApplicationRecord
  include Contributable
  include Publishable
  include Syncable
  include SluggableWithId
  include Taggable

  has_paper_trail

  belongs_to :category, optional: true
  has_one :saga
  has_many :illustrations, dependent: :destroy
  accepts_nested_attributes_for(
    :illustrations,
    reject_if: :all_blank,
    allow_destroy: true
  )

  validates :name, presence: true, length: { in: 2..100 }
  validates :page_type, presence: true

  # The list of page types.
  PAGE_TYPES = %w(
    literature
    literature_chapter
    top_level
  ).freeze

  has_attached_file(
    :page_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      information: '280x280>',
      embedded: '622x250#'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :page_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_validation :validate_category
  before_validation :validate_parent_page
  before_validation :validate_sequence_number
  before_validation :validate_description
  before_validation :validate_information

  before_save :set_published_at
  before_save :set_slug
  before_save :sync_file_name

  def sync_file_name
    sync_file_name_of :page_picture, file_name: "#{slug_from_name}.jpg"
  end

  def name_and_id
    "#{name} (#{id})"
  end

  def chapters
    Page.where(parent_page_id: id).order(:sequence_number)
  end

  def parent_page
    Page.where(id: parent_page_id).first
  end

  private

  def validate_category
    return unless page_type.present?
    if literature? && category.blank?
      errors.add(page_type, 'pages must have a category.')
    end
    if literature? && category.present? && category.category_type != :literature.to_s
      errors.add(page_type, 'pages must belong to a literature category.')
    end
    if !literature? && category.present?
      errors.add(page_type, 'pages must not have a category.')
    end
  end

  def validate_parent_page
    return unless page_type.present?
    if chapter? && parent_page_id.blank?
      errors.add(page_type, 'pages must belong to a parent page.')
    end
    if !chapter? && parent_page_id.present?
      errors.add(page_type, 'pages must not belong to a parent page.')
    end
  end

  def validate_sequence_number
    return unless page_type.present?
    if chapter? && sequence_number.blank?
      errors.add(page_type, 'pages must have a sequence number.')
    end
    if !chapter? && sequence_number.present?
      errors.add(page_type, 'pages must not have a sequence number.')
    end
  end

  def validate_description
    return unless page_type.present?
    if literature?
      if description.blank?
        errors.add(page_type, 'pages must have a description.')
      elsif description.length < 2 || description.length > 250
        errors.add(
          page_type, 'page descriptions must be between 2 and 250 characters.'
        )
      end
    end
    if !literature? && description.present?
      errors.add(page_type, 'pages must not have a description.')
    end
  end

  def validate_information
    return unless page_type.present?
    if information.present?
      errors.add(page_type, 'pages must not have an information box.')
    end
  end

  def literature?
    page_type == :literature.to_s
  end

  def chapter?
    page_type == :literature_chapter.to_s
  end
end
