require 'rails_helper'

describe EncyclopaediaEntryPolicy do
  subject { described_class.new(user, encyclopaedia_entry) }

  let(:resolved_scope) do
    described_class::Scope.new(user, EncyclopaediaEntry.all).resolve
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

    context 'creating a new encyclopaedia_entry' do
      let(:encyclopaedia_entry) { EncyclopaediaEntry.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing encyclopaedia entries in a published category' do
      context 'accessing encyclopaedia entries that the user does not ' \
              'contribute to' do
        context 'accessing a published encyclopaedia_entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_published_category
            )
          end

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_published_category
            )
          end

          it 'excludes encyclopaedia entry from resolved scope' do
            expect(resolved_scope).not_to include(encyclopaedia_entry)
          end

          it { is_expected.to forbid_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing encyclopaedia entries the user contributes to' do
        context 'accessing a published encyclopaedia entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to permit_edit_and_update_actions }
          it { is_expected.to permit_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context 'accessing encyclopaedia entries in an unpublished category' do
      context 'accessing encyclopaedia entries that the user does not ' \
              'contribute to' do
        context 'accessing a published encyclopaedia entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_published_category
            )
          end

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_published_category
            )
          end

          it 'excludes encyclopaedia entry from resolved scope' do
            expect(resolved_scope).not_to include(encyclopaedia_entry)
          end

          it { is_expected.to forbid_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing encyclopaedia entries that the user contributes to' do
        context 'accessing a published encyclopaedia_entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :published_encyclopaedia_entry_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished encyclopaedia entry' do
          let(:encyclopaedia_entry) do
            FactoryGirl.create(
              :unpublished_encyclopaedia_entry_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes encyclopaedia entry in resolved scope' do
            expect(resolved_scope).to include(encyclopaedia_entry)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to permit_edit_and_update_actions }
          it { is_expected.to permit_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end
  end
end
