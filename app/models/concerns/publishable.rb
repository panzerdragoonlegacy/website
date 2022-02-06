module Publishable
  extend ActiveSupport::Concern

  private

  def set_published_at
    # The first time the publishable is published:
    if published_at.blank? && publish
      # Set published_at field in the database to the current datetime:
      self.published_at = DateTime.now.utc
    end
  end
end
