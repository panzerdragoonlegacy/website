require 'rails_helper'

RSpec.describe MusicTrack, type: :model do
  describe 'fields' do
    it { should respond_to(:track_number) }
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:information) }
    it { should respond_to(:mp3_music_track) }
    it { should respond_to(:ogg_music_track) }
    it { should respond_to(:flac_music_track) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'validations' do
    it { should validate_presence_of(:track_number) }
    it do
      should validate_numericality_of(:track_number)
        .is_greater_than_or_equal_to(0).is_less_than_or_equal_to(50)
    end
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it do
      should validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end
    it { should validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      before do
        @contributor_profile = FactoryGirl.create :contributor_profile
        @music_track = FactoryGirl.create :valid_music_track
      end

      context 'music track has less than one contributor profile' do
        before do
          @music_track.contributor_profiles = []
        end

        it 'should not be valid' do
          expect(@music_track).not_to be_valid
        end
      end

      context 'music track has at least one contributor profile' do
        before do
          @music_track.contributor_profiles << @contributor_profile
        end

        it 'should be valid' do
          expect(@music_track).to be_valid
        end
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'file attachments' do
    it { should have_attached_file(:mp3_music_track) }
    it { should validate_attachment_presence(:mp3_music_track) }
    it do
      should validate_attachment_content_type(:mp3_music_track)
        .allowing('audio/mp3')
    end
    it do
      should validate_attachment_size(:mp3_music_track)
        .less_than(25.megabytes)
    end
    it { should have_attached_file(:ogg_music_track) }
    it { should validate_attachment_presence(:ogg_music_track) }
    it do
      should validate_attachment_content_type(:ogg_music_track)
        .allowing('audio/ogg')
    end
    it do
      should validate_attachment_size(:ogg_music_track)
        .less_than(25.megabytes)
    end
    it { should have_attached_file(:flac_music_track) }
    it do
      should validate_attachment_size(:flac_music_track)
        .less_than(50.megabytes)
    end
  end
end
