class ContributorProfile < ApplicationRecord
  include Publishable
  include SluggableWithoutId

  has_paper_trail

  has_one :user, dependent: :destroy
  has_many :news_entries, dependent: :destroy

  has_many :contributions, dependent: :destroy
  has_many(
    :pages,
    through: :contributions,
    source: :contributable,
    source_type: 'Page'
  )
  has_many(
    :albums,
    through: :contributions,
    source: :contributable,
    source_type: 'Album'
  )
  has_many(
    :pictures,
    through: :contributions,
    source: :contributable,
    source_type: 'Picture'
  )
  has_many(
    :music_tracks,
    through: :contributions,
    source: :contributable,
    source_type: 'MusicTrack'
  )
  has_many(
    :videos,
    through: :contributions,
    source: :contributable,
    source_type: 'Video'
  )
  has_many(
    :downloads,
    through: :contributions,
    source: :contributable,
    source_type: 'Download'
  )

  validates :name, presence: true, length: { in: 2..50 }, uniqueness: true

  before_save :set_published_at
  before_save :set_slug
  before_save :strip_discourse_url_to_just_username
  before_save :strip_bluesky_username_to_just_username
  before_save :strip_fediverse_username_to_just_username
  before_save :strip_facebook_url_to_just_username
  before_save :strip_twitter_url_to_just_username
  before_save :strip_instagram_url_to_just_username
  before_save :strip_deviantart_url_to_just_username

  has_attached_file(
    :avatar,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '75x75#',
      embedded: '280x280#'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:avatar_filename',
    url: '/system/:attachment/:id/:style/:avatar_filename'
  )

  validates_attachment(
    :avatar,
    content_type: {
      content_type: 'image/jpeg'
    },
    size: {
      in: 0..5.megabytes
    }
  )

  before_post_process :avatar_filename

  # Sets avatar filename in the database.
  def avatar_filename
    if avatar_content_type == 'image/jpeg'
      self.avatar_file_name = 'avatar.jpg' if avatar.present?
    end
  end

  # Sets avatar filename in the file system.
  Paperclip.interpolates :avatar_filename do |attachment, _style|
    attachment.instance.avatar_filename
  end

  private

  def strip_discourse_url_to_just_username
    if self.discourse_username
      self.discourse_username =
        self
          .discourse_username
          .sub('https://discuss.panzerdragoonlegacy.com/u/', '')
          .chomp('/')
    end
  end

  def strip_bluesky_username_to_just_username
    if self.bluesky_username
      self.bluesky_username =
        self
          .bluesky_username
          .sub('https://bsky.app/profile/', '')
          .delete_prefix('@')
    end
  end

  def strip_fediverse_username_to_just_username
    if self.fediverse_username
      self.fediverse_username = self.fediverse_username.delete_prefix('@')
    end
  end

  def strip_facebook_url_to_just_username
    if self.facebook_username
      self.facebook_username =
        self.facebook_username.sub('https://www.facebook.com/', '')
    end
  end

  def strip_twitter_url_to_just_username
    if self.twitter_username
      self.twitter_username =
        self
          .twitter_username
          .sub('https://x.com/', '')
          .sub('https://twitter.com/', '')
          .delete_prefix('@')
    end
  end

  def strip_instagram_url_to_just_username
    if self.instagram_username
      self.instagram_username =
        self.instagram_username.sub('https://www.instagram.com/', '').chomp('/')
    end
  end

  def strip_deviantart_url_to_just_username
    if self.deviantart_username
      self.deviantart_username =
        self.deviantart_username.sub('https://www.deviantart.com/', '')
    end
  end
end
