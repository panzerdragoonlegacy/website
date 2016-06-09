require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:encrypted_password) }
    it { is_expected.to respond_to(:reset_password_token) }
    it { is_expected.to respond_to(:reset_password_sent_at) }
    it { is_expected.to respond_to(:sign_in_count) }
    it { is_expected.to respond_to(:current_sign_in_at) }
    it { is_expected.to respond_to(:last_sign_in_at) }
    it { is_expected.to respond_to(:current_sign_in_ip) }
    it { is_expected.to respond_to(:last_sign_in_ip) }
    it { is_expected.to respond_to(:confirmation_token) }
    it { is_expected.to respond_to(:confirmed_at) }
    it { is_expected.to respond_to(:confirmation_sent_at) }
    it { is_expected.to respond_to(:unconfirmed_email) }
    it { is_expected.to respond_to(:failed_attempts) }
    it { is_expected.to respond_to(:unlock_token) }
    it { is_expected.to respond_to(:locked_at) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
    it { is_expected.to respond_to(:administrator) }
    it { is_expected.to respond_to(:contributor_profile) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contributor_profile) }
  end
end
