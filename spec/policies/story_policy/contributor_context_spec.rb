require 'rails_helper'

describe StoryPolicy do
  subject { described_class.new(user, story) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Story.all).resolve
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

    context 'creating a new story' do
      let(:story) { Story.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing stories in a published category' do
      context 'accessing stories that the user does not contribute to' do
        context 'accessing a published story' do
          let(:story) do
            FactoryGirl.create(:published_story_in_published_category)
          end

          it 'includes story in resolved scope' do
            expect(resolved_scope).to include(story)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished story' do
          let(:story) do
            FactoryGirl.create(:unpublished_story_in_published_category)
          end

          it 'excludes story from resolved scope' do
            expect(resolved_scope).not_to include(story)
          end

          it do
            is_expected.to forbid_actions([:show, :edit, :update, :destroy])
          end
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing stories the user contributes to' do
        context 'accessing a published story' do
          let(:story) do
            FactoryGirl.create(
              :published_story_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes story in resolved scope' do
            expect(resolved_scope).to include(story)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished story' do
          let(:story) do
            FactoryGirl.create(
              :unpublished_story_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes story in resolved scope' do
            expect(resolved_scope).to include(story)
          end

          it do
            is_expected.to permit_actions([:show, :edit, :update, :destroy])
          end
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context 'accessing stories in an unpublished category' do
      context 'accessing stories that the user does not contribute to' do
        context 'accessing a published story' do
          let(:story) do
            FactoryGirl.create(:published_story_in_published_category)
          end

          it 'includes story in resolved scope' do
            expect(resolved_scope).to include(story)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished story' do
          let(:story) do
            FactoryGirl.create(:unpublished_story_in_published_category)
          end

          it 'excludes story from resolved scope' do
            expect(resolved_scope).not_to include(story)
          end

          it do
            is_expected.to forbid_actions([:show, :edit, :update, :destroy])
          end
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing stories that the user contributes to' do
        context 'accessing a published story' do
          let(:story) do
            FactoryGirl.create(
              :published_story_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes story in resolved scope' do
            expect(resolved_scope).to include(story)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished story' do
          let(:story) do
            FactoryGirl.create(
              :unpublished_story_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes story in resolved scope' do
            expect(resolved_scope).to include(story)
          end

          it do
            is_expected.to permit_actions([:show, :edit, :update, :destroy])
          end
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end
  end
end
