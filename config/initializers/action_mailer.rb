Rails.application.config.action_mailer.smtp_settings = {
  address: Rails.application.secrets.smtp_settings['address'],
  port: Rails.application.secrets.smtp_settings['port'],
  user_name: Rails.application.secrets.smtp_settings['user_name'],
  password: Rails.application.secrets.smtp_settings['password']
}
