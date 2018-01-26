require 'rails_helper'

RSpec.describe Download, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:download) }
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
    it { is_expected.to have_attached_file(:download) }
    it { is_expected.to validate_attachment_presence(:download) }
    it do
      is_expected.to validate_attachment_content_type(:download)
        .allowing('application/zip')
    end
    it do
      is_expected.to validate_attachment_size(:download)
        .less_than(500.megabytes)
    end
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

      it 'sets the slug to be a parameterised version of the id + name' do
        download.save
        expect(download.to_param).to eq download.id.to_s + '-download-1'
      end
    end

    context 'updating a download' do
      let(:download) do
        FactoryGirl.create :valid_download, name: 'Download 1'
      end

      it 'sets the slug to be a parameterised version of the id + updated ' \
        'name' do
        download.name = 'Download 2'
        download.save
        expect(download.to_param).to eq download.id.to_s + '-download-2'
      end
    end
  end
end
