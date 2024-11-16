class Album < ApplicationRecord
  include Categorisable
  include Contributable
  include Instagramable
  include Publishable
  include Taggable
  include SluggableWithId
  include Syncable

  has_paper_trail

  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for(
    :pictures,
    reject_if: :all_blank,
    allow_destroy: true
  )
  has_many :videos, dependent: :destroy
  accepts_nested_attributes_for(
    :videos,
    reject_if: :all_blank,
    allow_destroy: true
  )

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  before_save :strip_instagram_url_to_just_id
  before_save :publish_in_sequence
  before_save :set_published_at
  before_save :set_slug
  after_save :update_picture_categories

  def name_and_id
    "#{name} (#{id})"
  end

  def ordered_pictures
    pictures.order :sequence_number, :name
  end

  def ordered_videos
    videos.order :sequence_number, :name
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name publish created_at updated_at published_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  private

  # Publishes the pictures/videos in the album one second apart (to ensure
  # unique published_at fields). This ensures that they will appear in the
  # Contributions Feed in sequence.
  def publish_in_sequence
    if publish
      self
        .pictures
        .sort_by { |p| p.sequence_number }
        .each do |picture|
          picture.publish = true
          if picture.published_at.blank?
            picture.published_at = DateTime.now.utc
            sleep 1
          end
        end
      self
        .videos
        .sort_by { |v| v.sequence_number }
        .each do |video|
          video.publish = true
          if video.published_at.blank?
            video.published_at = DateTime.now.utc
            sleep 1
          end
        end
    end
    set_published_at
  end

  def update_picture_categories
    pictures.each do |picture|
      if picture.category != category
        picture.category = category
        picture.save
      end
    end
  end
end
