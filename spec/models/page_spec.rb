require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:page_type) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:parent_page_id) }
    it { is_expected.to respond_to(:sequence_number) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:slug) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:page_picture) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
    it { is_expected.to respond_to(:published_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it do
      is_expected.to have_many(:contributor_profiles).through(:contributions)
    end
    it { is_expected.to have_many(:illustrations).dependent(:destroy) }
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  describe 'nested attributes' do
    it do
      is_expected.to accept_nested_attributes_for(:illustrations).allow_destroy(
        true
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:page_picture) }
    it do
      is_expected.to validate_attachment_content_type(:page_picture).allowing(
        'image/jpeg'
      )
    end
    it do
      is_expected.to validate_attachment_size(:page_picture).less_than(
        5.megabytes
      )
    end
  end

  # Todo: test custom validations
end
