require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:mp4_video_file_name) }
    it { is_expected.to respond_to(:youtube_video_id) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it do
      is_expected.to have_many(:contributor_profiles).through(:contributions)
    end
    it { is_expected.to have_many(:relations).dependent(:destroy) }
    it { is_expected.to have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category) }

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
    it { is_expected.to have_attached_file(:mp4_video) }
    it { is_expected.to validate_attachment_presence(:mp4_video) }
    it do
      is_expected.to validate_attachment_size(:mp4_video)
         .less_than(200.megabytes)
    end
  end

  describe 'slug' do
    context 'creating a new video' do
      let(:video) do
        FactoryGirl.build :valid_video, name: 'Video 1'
      end

      it 'sets the slug to be a parameterised version of the id + name' do
        video.save
        expect(video.to_param).to eq video.id.to_s + '-video-1'
      end
    end

    context 'updating a video' do
      let(:video) do
        FactoryGirl.create :valid_video, name: 'Video 1'
      end

      it 'sets the slug to be a parameterised version of the id + updated ' \
        'name' do
        video.name = 'Video 2'
        video.save
        expect(video.to_param).to eq video.id.to_s + '-video-2'
      end
    end
  end
end
