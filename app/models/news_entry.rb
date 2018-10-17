class NewsEntry < ActiveRecord::Base
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

  before_save :publish_news_entry
  before_save :sync_file_name

  private

  def publish_news_entry
    # The first time the news entry is published:
    if published_at.blank? && publish

      # Set published_at field in the database to the current datetime:
      self.published_at = DateTime.now.utc
    end
  end

  def sync_file_name
    sync_file_name_of(
      :news_entry_picture,
      file_name: "#{name.to_url}.jpg"
    )
  end
end
