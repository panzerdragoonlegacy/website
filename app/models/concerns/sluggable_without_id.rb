module SluggableWithoutId
  extend ActiveSupport::Concern
  include Sluggable

  def to_param
    slug
  end
end
