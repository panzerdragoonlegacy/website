Rails.application.config.action_mailer.smtp_settings = {
  address:   "smtp.mandrillapp.com",
  port:      587,
  user_name: Rails.application.secrets.mandrill["username"],
  password:  Rails.application.secrets.mandrill["api_key"]
}
