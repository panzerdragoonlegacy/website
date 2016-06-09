require 'rails_helper'

RSpec.describe Emoticon, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:code) }
    it { is_expected.to respond_to(:emoticon) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(25)
    end
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:emoticon) }
    it { is_expected.to validate_attachment_presence(:emoticon) }
    it do
      is_expected.to validate_attachment_content_type(:emoticon)
        .allowing('image/gif')
    end
    it do
      is_expected.to validate_attachment_size(:emoticon).less_than(1.megabyte)
    end
  end

  describe 'callbacks' do
    context 'before save' do
      it 'sets code to a lowercase verion of the name surrounded by colons' do
        valid_emoticon = FactoryGirl.build :valid_emoticon, name: 'New Name'
        valid_emoticon.save
        expect(valid_emoticon.code).to eq ':new-name:'
      end

      it "sets the emoticon file name to match the emoticon's name" do
        valid_emoticon = FactoryGirl.build :valid_emoticon, name: 'New Name'
        valid_emoticon.save
        expect(valid_emoticon.emoticon_file_name).to eq 'new-name.gif'
      end
    end
  end
end
