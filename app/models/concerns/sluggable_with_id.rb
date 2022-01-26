module SluggableWithId
  extend ActiveSupport::Concern
  include Sluggable

  def to_param
    "#{id}-#{slug}"
  end
end
