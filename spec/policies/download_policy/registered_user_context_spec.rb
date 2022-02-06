require 'rails_helper'

describe DownloadPolicy do
  subject { described_class.new(user, download) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Download.all).resolve
  end

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user creating a new download' do
    let(:download) { Download.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'registered user accessing downloads in a published category' do
    context 'accessing a published download' do
      let(:download) do
        FactoryBot.create(:published_download_in_published_category)
      end

      it 'includes download in resolved scope' do
        expect(resolved_scope).to include(download)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished download' do
      let(:download) do
        FactoryBot.create(:unpublished_download_in_published_category)
      end

      it 'excludes download from resolved scope' do
        expect(resolved_scope).not_to include(download)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'registered user accessing downloads in an unpublished category' do
    context 'accessing a published download' do
      let(:download) do
        FactoryBot.create(:published_download_in_unpublished_category)
      end

      it 'excludes download from resolved scope' do
        expect(resolved_scope).not_to include(download)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished download' do
      let(:download) do
        FactoryBot.create(:unpublished_download_in_unpublished_category)
      end

      it 'excludes download from resolved scope' do
        expect(resolved_scope).not_to include(download)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
