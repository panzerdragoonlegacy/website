require 'rails_helper'

describe ResourcePolicy do
  subject { ResourcePolicy.new(user, resource) }

  let(:resolved_scope) do
    ResourcePolicy::Scope.new(user, Resource.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new resource' do
      let(:resource) { Resource.new }

      it { should forbid_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing resources in a published category' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_published_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_published_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing resources in an unpublished category' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_unpublished_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_unpublished_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'creating a new resource' do
      let(:resource) { Resource.new }

      it { should forbid_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing resources in a published category' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_published_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_published_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing resources in an unpublished category' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_unpublished_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_unpublished_category)
        end

        it 'excludes resource from resolved scope' do
          expect(resolved_scope).not_to include(resource)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being a contributor' do
    let(:contributor_profile) do
      FactoryGirl.create(:contributor_profile)
    end
    let(:user) do
      FactoryGirl.create(
        :contributor,
        contributor_profile: contributor_profile
      )
    end

    context 'creating a new resource' do
      let(:resource) { Resource.new }

      it { should permit_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing resources in a published category' do
      context 'accessing resources that the user does not contribute to' do
        context 'accessing a published resource' do
          let(:resource) do
            FactoryGirl.create(:published_resource_in_published_category)
          end

          it 'includes resource in resolved scope' do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished resource' do
          let(:resource) do
            FactoryGirl.create(:unpublished_resource_in_published_category)
          end

          it 'excludes resource from resolved scope' do
            expect(resolved_scope).not_to include(resource)
          end

          it { should forbid_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
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

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
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

          it { should permit_action(:show) }
          it { should permit_edit_and_update_actions }
          it { should permit_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context 'accessing resources in an unpublished category' do
      context 'accessing resources that the user does not contribute to' do
        context 'accessing a published resource' do
          let(:resource) do
            FactoryGirl.create(:published_resource_in_published_category)
          end

          it 'includes resource in resolved scope' do
            expect(resolved_scope).to include(resource)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished resource' do
          let(:resource) do
            FactoryGirl.create(:unpublished_resource_in_published_category)
          end

          it 'excludes resource from resolved scope' do
            expect(resolved_scope).not_to include(resource)
          end

          it { should forbid_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
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

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
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

          it { should permit_action(:show) }
          it { should permit_edit_and_update_actions }
          it { should permit_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new resource' do
      let(:resource) { Resource.new }

      it { should permit_new_and_create_actions }
      it { should permit_mass_assignment_of(:publish) }
    end

    context 'accessing resources in a published category' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_published_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_published_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end
    end

    context 'accessing resources in an unpublished category' do
      context 'accessing a published resource' do
        let(:resource) do
          FactoryGirl.create(:published_resource_in_unpublished_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished resource' do
        let(:resource) do
          FactoryGirl.create(:unpublished_resource_in_unpublished_category)
        end

        it 'includes resource in resolved scope' do
          expect(resolved_scope).to include(resource)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end
    end
  end
end
