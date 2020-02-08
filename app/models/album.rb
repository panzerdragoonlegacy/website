class Album < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Publishable
  include Taggable
  include Syncable

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

  before_save :publish_in_sequence
  before_save :set_published_at
  after_save :update_picture_categories

  def to_param
    id.to_s + '-' + url
  end

  def name_and_id
    "#{name} (#{id})"
  end

  private

  # Publishes the pictures/videos in the album one second apart
  def publish_in_sequence
    if publish
      self.pictures.sort_by{ |p| p.sequence_number }.each do |picture|
        picture.publish = true
        if picture.published_at.blank?
          picture.published_at = DateTime.now.utc
          sleep 1
        end
      end
      self.videos.sort_by{ |v| v.sequence_number }.each do |video|
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
