require 'rails_helper'

describe DownloadPolicy do
  subject { described_class.new(user, download) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Download.all).resolve
  end

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new download' do
    let(:download) { Download.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'contributor accessing downloads that they do not contribute to' do
    context 'accessing a published download' do
      let(:download) { FactoryBot.create(:published_download) }

      it 'includes download in resolved scope' do
        expect(resolved_scope).to include(download)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished download' do
      let(:download) { FactoryBot.create(:unpublished_download) }

      it 'excludes download from resolved scope' do
        expect(resolved_scope).not_to include(download)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'contributor accessing downloads that they contribute to' do
    context 'accessing a published download' do
      let(:download) do
        FactoryBot.create(
          :published_download,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
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
        FactoryBot.create(
          :unpublished_download,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes download in resolved scope' do
        expect(resolved_scope).to include(download)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end

