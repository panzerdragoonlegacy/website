require 'rails_helper'

describe ResourcePolicy do
  subject { described_class.new(user, resource) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Resource.all).resolve
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

  context 'contributor creating a new resource' do
    let(:resource) { Resource.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'contributor accessing resources in a published category' do
    context 'accessing resources that the user does not contribute to' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_published_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_published_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it do
          is_expected.to forbid_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing resources the user contributes to' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(
            :published_resource_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(
            :unpublished_resource_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it do
          is_expected.to permit_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'contributor accessing resources in an unpublished category' do
    context 'accessing resources that the user does not contribute to' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_published_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_published_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it do
          is_expected.to forbid_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing resources that the user contributes to' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(
            :published_resource_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(
            :unpublished_resource_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it do
          is_expected.to permit_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end
end
