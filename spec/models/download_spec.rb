require 'rails_helper'

RSpec.describe Download, type: :model do
  describe 'fields' do
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
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it do
      should validate_length_of(:description).is_at_least(2).is_at_most(250)
    end
    it { should validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'download has less than one contributor profile' do
        let(:download) do
          FactoryGirl.build(
            :valid_download,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(download).not_to be_valid
        end
      end

      context 'download has at least one contributor profile' do
        let(:download) do
          FactoryGirl.build(
            :valid_download,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(download).to be_valid
        end
      end
    end
  end

  describe 'file attachment' do
    it { should have_attached_file(:download) }
    it { should validate_attachment_presence(:download) }
    it do
      should validate_attachment_content_type(:download)
        .allowing('application/zip')
    end
    it { should validate_attachment_size(:download).less_than(100.megabytes) }
  end

  describe 'callbacks' do
    context 'before save' do
      it "sets the download file name to match the download's name" do
        valid_download = FactoryGirl.build :valid_download, name: 'New Name'
        valid_download.save
        expect(valid_download.download_file_name).to eq 'new-name.zip'
      end
    end
  end

  describe 'slug' do
    context 'creating a new download' do
      let(:download) do
        FactoryGirl.build :valid_download, name: 'Download 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        download.save
        expect(download.url).to eq 'download-1'
      end
    end

    context 'updating a download' do
      let(:download) do
        FactoryGirl.create :valid_download, name: 'Download 1'
      end

      it 'synchronises the slug with the updated name' do
        download.name = 'Download 2'
        download.save
        expect(download.url).to eq 'download-2'
      end
    end
  end
end
