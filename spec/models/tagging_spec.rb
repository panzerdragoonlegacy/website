require 'rails_helper'

RSpec.describe Tagging, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:tag) }
    it { is_expected.to respond_to(:taggable) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to belong_to(:taggable) }
  end
end
