require 'rails_helper'

describe AlbumPolicy do
  subject { described_class.new(user, album) }

  let(:resolved_scope) { described_class::Scope.new(user, Album.all).resolve }

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user creating a new album' do
    let(:album) { Album.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'registered user accessing albums in a published category' do
    context 'accessing a published album' do
      let(:album) { FactoryBot.create(:published_album_in_published_category) }

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished album' do
      let(:album) do
        FactoryBot.create(:unpublished_album_in_published_category)
      end

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'registered user accessing albums in an unpublished category' do
    context 'accessing a published album' do
      let(:album) do
        FactoryBot.create(:published_album_in_unpublished_category)
      end

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished album' do
      let(:album) do
        FactoryBot.create(:unpublished_album_in_unpublished_category)
      end

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
