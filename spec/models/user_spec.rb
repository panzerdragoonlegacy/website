require 'rails_helper'

RSpec.describe User, type: :model do
  describe "fields" do
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:reset_password_sent_at) }
    it { should respond_to(:sign_in_count) }
    it { should respond_to(:current_sign_in_at) }
    it { should respond_to(:last_sign_in_at) }
    it { should respond_to(:current_sign_in_ip) }
    it { should respond_to(:last_sign_in_ip) }
    it { should respond_to(:confirmation_token) }
    it { should respond_to(:confirmed_at) }
    it { should respond_to(:confirmation_sent_at) }
    it { should respond_to(:unconfirmed_email) }
    it { should respond_to(:failed_attempts) }
    it { should respond_to(:unlock_token) }
    it { should respond_to(:locked_at) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:administrator) }
  end

  describe "validations" do
  end

  describe "associations" do
  end
end
