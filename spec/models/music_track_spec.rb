require 'rails_helper'

RSpec.describe MusicTrack, type: :model do
  describe "fields" do
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

  describe "validations" do
    it { should validate_presence_of(:track_number) }
    it { should validate_numericality_of(:track_number) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:description).is_at_least(2).is_at_most(250) }
    it { should validate_presence_of(:category) }
  end

  describe "associations" do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:dragoons).through(:contributions) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe "file attachments" do
    it { should have_attached_file(:mp3_music_track) }
    it { should validate_attachment_presence(:mp3_music_track) }
    it { should validate_attachment_content_type(:mp3_music_track).
      allowing('audio/mp3') }
    it { should validate_attachment_size(:mp3_music_track).
      less_than(25.megabytes) }
    it { should have_attached_file(:ogg_music_track) }
    it { should validate_attachment_presence(:ogg_music_track) }
    it { should validate_attachment_content_type(:ogg_music_track).
      allowing('audio/ogg') }
    it { should validate_attachment_size(:ogg_music_track).
      less_than(25.megabytes) }
    it { should have_attached_file(:flac_music_track) }
    it { should validate_attachment_size(:flac_music_track).
      less_than(50.megabytes) }
  end
end
