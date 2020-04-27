require 'rails_helper'

RSpec.describe Share, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:comment) }
    it { is_expected.to respond_to(:show_in_feed) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
    it { is_expected.to respond_to(:published_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:contributor_profile) }
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
    it do
      is_expected.to validate_length_of(:url).is_at_least(1).is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:comment) }
    it do
      is_expected.to validate_length_of(:comment).is_at_least(1).is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:contributor_profile) }
  end
end
