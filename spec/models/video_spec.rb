require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:information) }
    it { should respond_to(:mp4_video_file_name) }
    it { should respond_to(:webm_video_file_name) }
    it { should respond_to(:youtube_video_id) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_least(2).is_at_most(250) }
    it { should validate_presence_of(:category) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'file attachments' do
    it { should have_attached_file(:mp4_video) }
    it { should validate_attachment_presence(:mp4_video) }
    it { should validate_attachment_content_type(:mp4_video).
      allowing('video/mp4') }
    it { should validate_attachment_size(:mp4_video).
      less_than(200.megabytes) }
    it { should have_attached_file(:webm_video) }
    it { should validate_attachment_presence(:webm_video) }
    it { should validate_attachment_content_type(:webm_video).
      allowing('video/webm') }
    it { should validate_attachment_size(:webm_video).
      less_than(200.megabytes) }
  end
end
