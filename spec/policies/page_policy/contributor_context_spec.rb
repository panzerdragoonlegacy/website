require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Page.all).resolve
  end

  let(:contributor_profile) do
    FactoryGirl.create(:valid_contributor_profile)
  end
  let(:user) do
    FactoryGirl.create(
      :contributor,
      contributor_profile: contributor_profile
    )
  end

  context 'contributor creating a new page' do
    let(:page) { Page.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'contributor accessing pages in a published category' do
    context 'accessing pages that the user does not contribute to' do
      context 'accessing a published page' do
        let(:page) do
          FactoryGirl.create(:published_page_in_published_category)
        end

        it 'includes page in resolved scope' do
          expect(resolved_scope).to include(page)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i(edit update destroy)) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished page' do
        let(:page) do
          FactoryGirl.create(:unpublished_page_in_published_category)
        end

        it 'excludes page from resolved scope' do
          expect(resolved_scope).not_to include(page)
        end

        it do
          is_expected.to forbid_actions(%i(show edit update destroy))
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing pages the user contributes to' do
      context 'accessing a published page' do
        let(:page) do
          FactoryGirl.create(
            :published_page_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes page in resolved scope' do
          expect(resolved_scope).to include(page)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i(edit update destroy)) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished page' do
        let(:page) do
          FactoryGirl.create(
            :unpublished_page_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes page in resolved scope' do
          expect(resolved_scope).to include(page)
        end

        it do
          is_expected.to permit_actions(%i(show edit update destroy))
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'contributor accessing pages in an unpublished category' do
    context 'accessing pages that the user does not contribute to' do
      context 'accessing a published page' do
        let(:page) do
          FactoryGirl.create(:published_page_in_published_category)
        end

        it 'includes page in resolved scope' do
          expect(resolved_scope).to include(page)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i(edit update destroy)) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished page' do
        let(:page) do
          FactoryGirl.create(:unpublished_page_in_published_category)
        end

        it 'excludes page from resolved scope' do
          expect(resolved_scope).not_to include(page)
        end

        it do
          is_expected.to forbid_actions(%i(show edit update destroy))
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing pages that the user contributes to' do
      context 'accessing a published page' do
        let(:page) do
          FactoryGirl.create(
            :published_page_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes page in resolved scope' do
          expect(resolved_scope).to include(page)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions(%i(edit update destroy)) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished page' do
        let(:page) do
          FactoryGirl.create(
            :unpublished_page_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes page in resolved scope' do
          expect(resolved_scope).to include(page)
        end

        it do
          is_expected.to permit_actions(%i(show edit update destroy))
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end
end
