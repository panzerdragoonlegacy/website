require 'rails_helper'

describe DownloadPolicy do
  subject { described_class.new(user, download) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Download.all).resolve
  end

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new download' do
    let(:download) { Download.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing a published download' do
    let(:download) { FactoryBot.create(:published_download) }

    it 'includes download in resolved scope' do
      expect(resolved_scope).to include(download)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'accessing an unpublished download' do
    let(:download) { FactoryBot.create(:unpublished_download) }

    it 'includes download in resolved scope' do
      expect(resolved_scope).to include(download)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end
end
