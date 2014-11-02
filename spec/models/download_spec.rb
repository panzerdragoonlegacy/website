require 'rails_helper'

RSpec.describe Download, type: :model do
  describe "fields" do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:information) }
    it { should respond_to(:download) }
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
    it { should have_attached_file(:download) }
    it { should validate_attachment_presence(:download) }
    it { should validate_attachment_content_type(:download).
      allowing('application/zip') }
    it { should validate_attachment_size(:download).less_than(100.megabytes) }
  end

  describe "callbacks" do
    context "before save" do
      it "sets the download file name to match the download's name" do
        valid_download = FactoryGirl.build :valid_download, name: "New Name"
        valid_download.save
        expect(valid_download.download_file_name).to eq "new-name.zip"
      end
    end
  end
end
