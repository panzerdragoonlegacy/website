require 'rails_helper'

RSpec.describe EncyclopaediaEntry, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:information) }
    it { should respond_to(:content) }
    it { should respond_to(:encyclopaedia_entry_picture) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:information) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:category) }
  end

  describe "associations" do
    it { should belong_to(:category) }
    it { should have_one(:saga).dependent(:destroy) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:illustrations).dependent(:destroy) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:articles) }
    it { should have_many(:downloads) }
    it { should have_many(:links) }
    it { should have_many(:music_tracks) }
    it { should have_many(:pictures) }
    it { should have_many(:poems) }
    it { should have_many(:quizzes) }
    it { should have_many(:resources) }
    it { should have_many(:stories) }
    it { should have_many(:videos) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:illustrations).
      allow_destroy(true) }
  end

  describe "file attachment" do
    it { should have_attached_file(:encyclopaedia_entry_picture) }
    it { should validate_attachment_presence(:encyclopaedia_entry_picture) }
    it { should validate_attachment_content_type(:encyclopaedia_entry_picture).
      allowing('image/jpeg') }
    it { should validate_attachment_size(:encyclopaedia_entry_picture).
      less_than(5.megabytes) }
  end

  describe "callbacks" do
    context "before save" do
      it "sets the entry's picture file name to match the entry's name" do
        valid_encyclopaedia_entry = FactoryGirl.build :valid_encyclopaedia_entry
        valid_encyclopaedia_entry.name = "New Name"
        valid_encyclopaedia_entry.save
        expect(valid_encyclopaedia_entry.encyclopaedia_entry_picture_file_name).
          to eq "new-name.jpg"
      end
    end
  end
end
