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

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it do
      should validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { should validate_presence_of(:description) }
    it do
      should validate_length_of(:description).is_at_least(2).is_at_most(250)
    end
    it { should validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'video has less than one contributor profile' do
        let(:video) do
          FactoryGirl.build(
            :valid_video,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(video).not_to be_valid
        end
      end

      context 'video has at least one contributor profile' do
        let(:video) do
          FactoryGirl.build(
            :valid_video,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(video).to be_valid
        end
      end
    end
  end

  describe 'file attachments' do
    it { should have_attached_file(:mp4_video) }
    it { should validate_attachment_presence(:mp4_video) }
    it do
      should validate_attachment_content_type(:mp4_video)
        .allowing('video/mp4')
    end
    it do
      should validate_attachment_size(:mp4_video).less_than(200.megabytes)
    end
    it { should have_attached_file(:webm_video) }
    it { should validate_attachment_presence(:webm_video) }
    it do
      should validate_attachment_content_type(:webm_video)
        .allowing('video/webm')
    end
    it do
      should validate_attachment_size(:webm_video)
        .less_than(200.megabytes)
    end
  end

  describe 'slug' do
    context 'creating a new video' do
      let(:video) do
        FactoryGirl.build :valid_video, name: 'Video 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        video.save
        expect(video.url).to eq 'video-1'
      end
    end

    context 'updating a video' do
      let(:video) do
        FactoryGirl.create :valid_video, name: 'Video 1'
      end

      it 'synchronises the slug with the updated name' do
        video.name = 'Video 2'
        video.save
        expect(video.url).to eq 'video-2'
      end
    end
  end
end
