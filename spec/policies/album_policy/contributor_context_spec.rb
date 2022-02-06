require 'rails_helper'

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
  end

  context 'contributor accessing albums in a published category' do
    context 'accessing albums that the user does not contribute to' do
      context 'accessing a published album' do
        let(:album) do
          FactoryBot.create(:published_album_in_published_category)
        end

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

    context 'accessing albums the user contributes to' do
      context 'accessing a published album' do
        let(:album) do
          FactoryBot.create(
            :published_album_in_published_category,
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
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished album' do
        let(:album) do
          FactoryBot.create(
            :unpublished_album_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes album in resolved scope' do
          expect(resolved_scope).to include(album)
        end

        it { is_expected.to permit_actions(%i[show edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'contributor accessing albums in an unpublished category' do
    context 'accessing albums that the user does not contribute to' do
      context 'accessing a published album' do
        let(:album) do
          FactoryBot.create(:published_album_in_published_category)
        end

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

    context 'accessing albums that the user contributes to' do
      context 'accessing a published album' do
        let(:album) do
          FactoryBot.create(
            :published_album_in_unpublished_category,
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
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished album' do
        let(:album) do
          FactoryBot.create(
            :unpublished_album_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes album in resolved scope' do
          expect(resolved_scope).to include(album)
        end

        it { is_expected.to permit_actions(%i[show edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end
end
