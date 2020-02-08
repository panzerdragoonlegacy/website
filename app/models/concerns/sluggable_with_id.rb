module SluggableWithId
  extend ActiveSupport::Concern

  included do
    acts_as_url :name, sync_url: true, allow_duplicates: :true
  end

  def to_param
    id.to_s + '-' + url
  end
end
