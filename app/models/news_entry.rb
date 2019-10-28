class NewsEntry < ActiveRecord::Base
  include Categorisable
  include Publishable
  include Sluggable
  include Syncable
  include Taggable

  belongs_to :contributor_profile

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :content, presence: true
  validates :contributor_profile, presence: true

  has_attached_file(
    :news_entry_picture,
    styles: {
      thumbnail: '150x150',
      embedded: '622x250#'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :news_entry_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )
  validates_attachment :news_entry_picture, presence: true

  before_save :set_published_at
  before_save :sync_file_name

  private

  def sync_file_name
    sync_file_name_of(
      :news_entry_picture,
      file_name: "#{name.to_url}.jpg"
    )
  end
end
