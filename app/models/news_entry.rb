class NewsEntry < ActiveRecord::Base
  include Sluggable
  
  belongs_to :dragoon
  
  validates :name, presence: true, length: { in: 2..55 }, uniqueness: true
  validates :content, presence: true

  before_save :publish_news_entry
    
  def publish_news_entry
    # The first time the news entry is published:
    if self.published_at.blank? && self.publish
      
      # Set published_at field in the database to the current datetime:
      self.published_at = DateTime.now
      
      full_url = "http://www.thewilloftheancients.com/news/" + self.url
      
      # Post the status update field + short URL to Twitter:
      client = Twitter::Client.new
      if self.name[-1] == "?" or self.name[-1] == "!"
        client.update(self.name + " " + full_url)
      else
        client.update(self.name + ": " + full_url)
      end    
    end
  end
end
