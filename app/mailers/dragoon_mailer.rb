class DragoonMailer < ActionMailer::Base
  default :from => "noreply@thewilloftheancients.com"

  def reset_password(dragoon)
    @dragoon = dragoon
    mail(:to => dragoon.email_address, :subject => "Reset Password")
  end
end
