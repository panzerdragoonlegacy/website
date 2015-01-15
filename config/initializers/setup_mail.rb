ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => Rails.application.secrets.mail["user_name"],
  :password             => Rails.application.secrets.mail["password"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
