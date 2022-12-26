require 'rails_helper'

describe AlbumPolicy do
  subject { described_class.new(user, album) }

  let(:resolved_scope) { described_class::Scope.new(user, Album.all).resolve }

  let(:user) { nil }

  context 'visitor creating a new album' do
    let(:album) { Album.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'visitor accessing a published album' do
    let(:album) { FactoryBot.create(:published_album) }

    it 'includes album in resolved scope' do
      expect(resolved_scope).to include(album)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'visitor accessing an unpublished album' do
    let(:album) { FactoryBot.create(:unpublished_album) }

    it 'excludes album from resolved scope' do
      expect(resolved_scope).not_to include(album)
    end

    it { is_expected.to forbid_actions(%i[show edit update destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end
end
