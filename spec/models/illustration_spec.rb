require 'rails_helper'

RSpec.describe Illustration, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:illustration) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:page) }
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:illustration) }
    it { is_expected.to validate_attachment_presence(:illustration) }
    it do
      is_expected.to validate_attachment_content_type(:illustration).allowing(
        'image/jpeg'
      )
    end
    it do
      is_expected.to validate_attachment_size(:illustration).less_than(
        5.megabytes
      )
    end
  end

  describe 'callbacks' do
    context 'before save' do
      it 'sets the illustration file name to a lowercase, hyphenated version' do
        valid_page = FactoryBot.build :valid_page
        illustration = FactoryBot.build :illustration
        illustration.page = valid_page
        illustration.illustration_file_name = 'New File Name.jpg'
        illustration.save
        expect(illustration.illustration_file_name).to eq 'new-file-name.jpg'
      end
    end
  end
end
