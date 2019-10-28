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

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  before_save :set_published_at
  after_save :update_picture_categories

  def to_param
    id.to_s + '-' + url
  end

  def name_and_id
    "#{name} (#{id})"
  end

  private

  def update_picture_categories
    pictures.each do |picture|
      if picture.category != category
        picture.category = category
        picture.save
      end
    end
  end
end
