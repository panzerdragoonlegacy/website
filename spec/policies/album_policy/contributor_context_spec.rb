require 'rails_helper'
require './spec/support/album_policy_helpers'

describe AlbumPolicy do
  subject { described_class.new(user, album) }

  let(:resolved_scope) { described_class::Scope.new(user, Album.all).resolve }

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new album' do
    let(:album) { Album.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
    it do
      is_expected.to permit_mass_assignment_of(album_attributes_except_publish)
    end
  end

  context 'contributor accessing albums that the user does not contribute to' do
    context 'accessing a published album' do
      let(:album) { FactoryBot.create(:published_album) }

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to permit_only_actions(%i[new create show]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
      it do
        is_expected.to permit_mass_assignment_of(
          album_attributes_except_publish
        )
      end
    end

    context 'accessing an unpublished album' do
      let(:album) { FactoryBot.create(:unpublished_album) }

      it 'excludes album from resolved scope' do
        expect(resolved_scope).not_to include(album)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_only_actions(%i[new create]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
      it do
        is_expected.to permit_mass_assignment_of(
          album_attributes_except_publish
        )
      end
    end
  end

  context 'contributor accessing albums the user contributes to' do
    context 'accessing a published album' do
      let(:album) do
        FactoryBot.create(
          :published_album,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to permit_only_actions(%i[new create show]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
      it do
        is_expected.to permit_mass_assignment_of(
          album_attributes_except_publish
        )
      end
    end

    context 'accessing an unpublished album' do
      let(:album) do
        FactoryBot.create(
          :unpublished_album,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes album in resolved scope' do
        expect(resolved_scope).to include(album)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_all_actions }

      it { is_expected.to forbid_mass_assignment_of(:publish) }
      it do
        is_expected.to permit_mass_assignment_of(
          album_attributes_except_publish
        )
      end
    end
  end
end
