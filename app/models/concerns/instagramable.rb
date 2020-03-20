module Instagramable
  extend ActiveSupport::Concern

  private

  def strip_instagram_url_to_just_id
    if self.instagram_post_id
      self.instagram_post_id = self.instagram_post_id
        .sub('https://www.instagram.com/p/', '').chomp('/')
    end
  end
end
