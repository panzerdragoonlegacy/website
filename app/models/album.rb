class Album < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Syncable

  has_many :pictures, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  def to_param
    id.to_s + '-' + url
  end

  def name_and_id
    "#{name} (#{id})"
  end
end
