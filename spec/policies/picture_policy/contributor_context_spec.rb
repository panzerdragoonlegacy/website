require 'rails_helper'

describe PicturePolicy do
  subject { described_class.new(user, picture) }

  let(:resolved_scope) { described_class::Scope.new(user, Picture.all).resolve }

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new picture' do
    let(:picture) { Picture.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'contributor accessing pictures in a published category' do
    context 'accessing pictures that the user does not contribute to' do
      context 'accessing a published picture' do
        let(:picture) do
          FactoryBot.create(:published_picture_in_published_category)
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i[edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished picture' do
        let(:picture) do
          FactoryBot.create(:unpublished_picture_in_published_category)
        end

        it 'excludes picture from resolved scope' do
          expect(resolved_scope).not_to include(picture)
        end

        it { is_expected.to forbid_actions(%i[show edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing pictures the user contributes to' do
      context 'accessing a published picture' do
        let(:picture) do
          FactoryBot.create(
            :published_picture_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i[edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished picture' do
        let(:picture) do
          FactoryBot.create(
            :unpublished_picture_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_actions(%i[show edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'contributor accessing pictures in an unpublished category' do
    context 'accessing pictures that the user does not contribute to' do
      context 'accessing a published picture' do
        let(:picture) do
          FactoryBot.create(:published_picture_in_published_category)
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i[edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished picture' do
        let(:picture) do
          FactoryBot.create(:unpublished_picture_in_published_category)
        end

        it 'excludes picture from resolved scope' do
          expect(resolved_scope).not_to include(picture)
        end

        it { is_expected.to forbid_actions(%i[show edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing pictures that the user contributes to' do
      context 'accessing a published picture' do
        let(:picture) do
          FactoryBot.create(
            :published_picture_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i[edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished picture' do
        let(:picture) do
          FactoryBot.create(
            :unpublished_picture_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes picture in resolved scope' do
          expect(resolved_scope).to include(picture)
        end

        it { is_expected.to permit_actions(%i[show edit update destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end
end
