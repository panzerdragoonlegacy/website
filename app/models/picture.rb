class Picture < ApplicationRecord
  include Categorisable
  include Contributable
  include Instagramable
  include Publishable
  include Taggable
  include SluggableWithId
  include Syncable

  has_paper_trail

  belongs_to :album, optional: true

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }
  validates(
    :sequence_number,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 999
    }
  )

  has_attached_file(
    :picture,
    styles: {
      mini_thumbnail: '75x75#',
      news_entry_thumbnail: '100x100#',
      thumbnail: '150x150>',
      triple_thumbnail: '150x150#',
      double_thumbnail: '238x238#',
      single_thumbnail: '486x486>',
      embedded: '625x625>'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :picture,
    presence: true,
    content_type: {
      content_type: 'image/jpeg'
    },
    size: {
      in: 0..25.megabytes
    }
  )

  before_save :set_published_at
  before_save :set_slug
  before_save :sync_file_name
  before_save :replace_picture
  before_save :strip_instagram_url_to_just_id

  def sync_file_name
    sync_file_name_of :picture, file_name: "#{slug_from_name}.jpg"
  end

  def name_and_id
    "#{name} (#{id})"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name publish instagram_post_id created_at updated_at published_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  private

  def replace_picture
    if publish && id_of_picture_to_replace.present?
      picture_to_replace = Picture.find(id_of_picture_to_replace)
      picture_to_replace.destroy
    end
  end
end
