require 'rails_helper'

describe AlbumPolicy do
  subject { described_class.new(user, album) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Album.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing an album' do
      let(:album) do
        FactoryGirl.create(:valid_album)
      end

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'accessing an album' do
      let(:album) do
        FactoryGirl.create(:valid_album)
      end

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'being a contributor' do
    let(:contributor_profile) do
      FactoryGirl.create(:valid_contributor_profile)
    end
    let(:user) do
      FactoryGirl.create(
        :contributor,
        contributor_profile: contributor_profile
      )
    end

    context 'creating a new album' do
      let(:album) { Album.new }

      it { is_expected.to permit_new_and_create_actions }
    end

    context 'accessing albums that the user does not contribute to' do
      let(:album) { FactoryGirl.create(:valid_album) }

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'accessing albums that the user contributes to' do
      let(:album) do
        FactoryGirl.create(
          :valid_album,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }

      context 'album has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'album has children' do
        before do
          album.pictures << FactoryGirl.create(:valid_picture)
        end

        it { is_expected.to forbid_action(:destroy) }
      end
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new album' do
      let(:album) { Poem.new }

    end

    context 'accessing an album' do
      let(:album) { FactoryGirl.create(:valid_album) }

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_edit_and_update_actions }

      context 'album has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'album has children' do
        before do
          album.pictures << FactoryGirl.create(:valid_picture)
        end

        it { is_expected.to forbid_action(:destroy) }
      end
    end
  end
end
