class NewsEntry < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param
    url 
  end

  before_save :publish_news_entry
  
  belongs_to :dragoon
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates :name, :presence => true, :length => { :in => 2..55 }, :uniqueness => true
  validates :content, :presence => true
    
  def publish_news_entry
    # The first time the news entry is published:
    if self.published_at.blank? && self.publish
      
      # Set published_at field in the database to the current datetime:
      self.published_at = DateTime.now
      
      # Create short URL of news entry using bitly:
      Bitly.use_api_version_3
      bitly = Bitly.new(APP_CONFIG['bitly']['username'], APP_CONFIG['bitly']['api_key'])
      u = bitly.shorten("http://www.thewilloftheancients.com/news/" + self.url)
      self.short_url = u.short_url
      
      # Post the status update field + short URL to Twitter:
      client = Twitter::Client.new
      client.update(self.name + ": " + self.short_url)
      
    end
  end
end