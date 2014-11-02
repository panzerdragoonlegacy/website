require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:information) }
    it { should respond_to(:picture) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "validations" do
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

  describe "file attachment" do
    it { should have_attached_file(:picture) }
    it { should validate_attachment_presence(:picture) }
    it { should validate_attachment_content_type(:picture).
      allowing('image/jpeg') }
    it { should validate_attachment_size(:picture).
      less_than(5.megabytes) }
  end

  describe "callbacks" do
    context "before save" do
      it "sets the picture file name to match the picture's name" do
        valid_picture = FactoryGirl.build :valid_picture, name: "New Name"
        valid_picture.save
        expect(valid_picture.picture_file_name).to eq "new-name.jpg"
      end
    end
  end
end
