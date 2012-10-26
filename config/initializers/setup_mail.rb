ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => APP_CONFIG['mail']['user_name'],
  :password             => APP_CONFIG['mail']['password'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}