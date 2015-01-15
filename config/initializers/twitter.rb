Twitter.configure do |config|
  config.consumer_key = Rails.application.secrets.twitter["consumer_key"]
  config.consumer_secret = Rails.application.secrets.twitter["consumer_secret"]
  config.oauth_token = Rails.application.secrets.twitter["oauth_token"]
  config.oauth_token_secret = Rails.application.secrets.twitter["oauth_token_secret"]
end
