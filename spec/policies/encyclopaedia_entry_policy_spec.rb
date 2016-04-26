require 'rails_helper'

describe EncyclopaediaEntryPolicy do
  subject { EncyclopaediaEntryPolicy.new(user, encyclopaedia_entry) }

  let(:resolved_scope) {
    EncyclopaediaEntryPolicy::Scope.new(user, EncyclopaediaEntry.all).resolve
  }

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new encyclopaedia entry' do
      let(:encyclopaedia_entry) { EncyclopaediaEntry.new }

      it { should forbid_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing encyclopaedia entries in a published category' do
      context 'accessing a published encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :published_encyclopaedia_entry_in_published_category
          )
        }

        it 'includes encyclopaedia entry in resolved scope' do
          expect(resolved_scope).to include(encyclopaedia_entry)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :unpublished_encyclopaedia_entry_in_published_category
          )
        }

        it 'excludes encyclopaedia entry from resolved scope' do
          expect(resolved_scope).not_to include(encyclopaedia_entry)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing encyclopaedia entries in an unpublished category' do
      context 'accessing a published encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :published_encyclopaedia_entry_in_unpublished_category
          )
        }

        it 'excludes encyclopaedia entry from resolved scope' do
          expect(resolved_scope).not_to include(encyclopaedia_entry)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :unpublished_encyclopaedia_entry_in_unpublished_category
          )
        }

        it 'excludes encyclopaedia entry from resolved scope' do
          expect(resolved_scope).not_to include(encyclopaedia_entry)
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

    context 'creating a new encyclopaedia entry' do
      let(:encyclopaedia_entry) { EncyclopaediaEntry.new }

      it { should forbid_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing encyclopaedia entries in a published category' do
      context 'accessing a published encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :published_encyclopaedia_entry_in_published_category
          )
        }

        it 'includes encyclopaedia entry in resolved scope' do
          expect(resolved_scope).to include(encyclopaedia_entry)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :unpublished_encyclopaedia_entry_in_published_category
          )
        }

        it 'excludes encyclopaedia entry from resolved scope' do
          expect(resolved_scope).not_to include(encyclopaedia_entry)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing encyclopaedia entries in an unpublished category' do
      context 'accessing a published encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :published_encyclopaedia_entry_in_unpublished_category
          )
        }

        it 'excludes encyclopaedia entry from resolved scope' do
          expect(resolved_scope).not_to include(encyclopaedia_entry)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :unpublished_encyclopaedia_entry_in_unpublished_category
          )
        }

        it 'excludes encyclopaedia entry from resolved scope' do
          expect(resolved_scope).not_to include(encyclopaedia_entry)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being a contributor' do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor,
        contributor_profile: contributor_profile
      )
    }

    context 'creating a new encyclopaedia_entry' do
      let(:encyclopaedia_entry) { EncyclopaediaEntry.new }

      it { should permit_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing encyclopaedia entries in a published category' do
      context 'accessing encyclopaedia entries that the user does not ' +
        'contribute to' do
        context 'accessing a published encyclopaedia_entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_published_category
            )
          }

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_published_category
            )
          }

          it 'excludes encyclopaedia entry from resolved scope' do
            expect(resolved_scope).not_to include(encyclopaedia_entry)
          end

          it { should forbid_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing encyclopaedia entries the user contributes to' do
        context 'accessing a published encyclopaedia entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { should permit_action(:show) }
          it { should permit_edit_and_update_actions }
          it { should permit_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context 'accessing encyclopaedia entries in an unpublished category' do
      context 'accessing encyclopaedia entries that the user does not ' +
        'contribute to' do
        context 'accessing a published encyclopaedia entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_published_category
            )
          }

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_published_category
            )
          }

          it 'excludes encyclopaedia entry from resolved scope' do
            expect(resolved_scope).not_to include(encyclopaedia_entry)
          end

          it { should forbid_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing encyclopaedia entries that the user contributes to' do
        context 'accessing a published encyclopaedia_entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { should permit_action(:show) }
          it { should forbid_edit_and_update_actions }
          it { should forbid_action(:destroy) }
          it { should forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) {
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
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

    context 'creating a new encyclopaedia entry' do
      let(:encyclopaedia_entry) { EncyclopaediaEntry.new }

      it { should permit_new_and_create_actions }
      it { should permit_mass_assignment_of(:publish) }
    end

    context 'accessing encyclopaedia entries in a published category' do
      context 'accessing a published encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :published_encyclopaedia_entry_in_published_category
          )
        }

        it 'includes encyclopaedia entry in resolved scope' do
          expect(resolved_scope).to include(encyclopaedia_entry)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :unpublished_encyclopaedia_entry_in_published_category
          )
        }

        it 'includes encyclopaedia entry in resolved scope' do
          expect(resolved_scope).to include(encyclopaedia_entry)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end
    end

    context 'accessing encyclopaedia entries in an unpublished category' do
      context 'accessing a published encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :published_encyclopaedia_entry_in_unpublished_category
          )
        }

        it 'includes encyclopaedia entry in resolved scope' do
          expect(resolved_scope).to include(encyclopaedia_entry)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished encyclopaedia entry' do
        let(:encyclopaedia_entry) {
          FactoryGirl.create(
            :unpublished_encyclopaedia_entry_in_unpublished_category
          )
        }

        it 'includes encyclopaedia entry in resolved scope' do
          expect(resolved_scope).to include(encyclopaedia_entry)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should permit_mass_assignment_of(:publish) }
      end
    end
  end
end
