require 'rails_helper'

RSpec.describe MusicTrack, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:track_number) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:slug) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:mp3_music_track) }
    it { is_expected.to respond_to(:flac_music_track) }
    it { is_expected.to respond_to(:music_track_picture) }
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
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:track_number) }
    it do
      is_expected.to validate_numericality_of(:track_number)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(50)
    end
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description)
        .is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'music track has less than one contributor profile' do
        let(:music_track) do
          FactoryBot.build(:valid_music_track, contributor_profiles: [])
        end

        it 'should not be valid' do
          expect(music_track).not_to be_valid
        end
      end

      context 'music track has at least one contributor profile' do
        let(:music_track) do
          FactoryBot.build(
            :valid_music_track,
            contributor_profiles: [
              FactoryBot.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(music_track).to be_valid
        end
      end
    end
  end

  describe 'file attachments' do
    it { is_expected.to have_attached_file(:mp3_music_track) }
    it { is_expected.to validate_attachment_presence(:mp3_music_track) }
    it do
      is_expected.to validate_attachment_size(:mp3_music_track).less_than(
        25.megabytes
      )
    end
    it { is_expected.to have_attached_file(:flac_music_track) }
    it do
      is_expected.to validate_attachment_size(:flac_music_track).less_than(
        50.megabytes
      )
    end
    it { is_expected.to have_attached_file(:music_track_picture) }
    it do
      is_expected.to validate_attachment_size(:music_track_picture).less_than(
        5.megabytes
      )
    end
  end

  describe 'slug' do
    context 'creating a new music track' do
      let(:music_track) do
        FactoryBot.build :valid_music_track, name: 'Music Track 1'
      end

      it 'sets the slug to be a parameterised version of the id + name' do
        music_track.save
        expect(music_track.to_param).to eq(
          music_track.id.to_s + '-music-track-1'
        )
      end
    end

    context 'updating a music track' do
      let(:music_track) do
        FactoryBot.create :valid_music_track, name: 'Music Track 1'
      end

      it 'sets the slug to be a parameterised version of the id + updated ' \
           'name' do
        music_track.name = 'Music Track 2'
        music_track.save
        expect(music_track.to_param).to eq(
          music_track.id.to_s + '-music-track-2'
        )
      end
    end
  end
end
