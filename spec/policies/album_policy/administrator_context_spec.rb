require 'rails_helper'

describe AlbumPolicy do
  subject { described_class.new(user, album) }

  let(:resolved_scope) { described_class::Scope.new(user, Album.all).resolve }

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new album' do
    let(:album) { Album.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing albums in a published category' do
    context 'accessing a published album' do
      let(:album) { FactoryBot.create(:published_album_in_published_category) }

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_actions(%i[show edit update]) }

      context 'album has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'album has children' do
        before { album.pictures << FactoryBot.create(:valid_picture) }

        it { is_expected.to forbid_action(:destroy) }
      end

      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished album' do
      let(:album) do
        FactoryBot.create(:unpublished_album_in_published_category)
      end

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_actions(%i[show edit update]) }

      context 'album has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'album has children' do
        before { album.pictures << FactoryBot.create(:valid_picture) }

        it { is_expected.to forbid_action(:destroy) }
      end

      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing albums in an unpublished category' do
    context 'accessing a published album' do
      let(:album) do
        FactoryBot.create(:published_album_in_unpublished_category)
      end

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_actions(%i[show edit update]) }

      context 'album has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'album has children' do
        before { album.pictures << FactoryBot.create(:valid_picture) }

        it { is_expected.to forbid_action(:destroy) }
      end

      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished album' do
      let(:album) do
        FactoryBot.create(:unpublished_album_in_unpublished_category)
      end

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_actions(%i[show edit update]) }

      context 'album has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'album has children' do
        before { album.pictures << FactoryBot.create(:valid_picture) }

        it { is_expected.to forbid_action(:destroy) }
      end

      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
