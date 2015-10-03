require 'rails_helper'

describe StoryPolicy do
  subject { StoryPolicy.new(user, story) }

  let(:resolved_scope) {
    StoryPolicy::Scope.new(user, Story.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing stories in a published category" do
      context "accessing a published story" do
        let(:story) {
          FactoryGirl.create(:published_story_in_published_category)
        }

        it "includes story in resolved scope" do
          expect(resolved_scope).to include(story)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished story" do
        let(:story) {
          FactoryGirl.create(:unpublished_story_in_published_category)
        }

        it "excludes story from resolved scope" do
          expect(resolved_scope).not_to include(story)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
    
    context "accessing stories in an unpublished category" do
      context "accessing a published story" do
        let(:story) {
          FactoryGirl.create(:published_story_in_unpublished_category)
        }

        it "excludes story from resolved scope" do
          expect(resolved_scope).not_to include(story)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished story" do
        let(:story) {
          FactoryGirl.create(:unpublished_story_in_unpublished_category)
        }

        it "excludes story from resolved scope" do
          expect(resolved_scope).not_to include(story)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing stories in a published category" do
      context "accessing a published story" do
        let(:story) {
          FactoryGirl.create(:published_story_in_published_category)
        }

        it "includes story in resolved scope" do
          expect(resolved_scope).to include(story)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished story" do
        let(:story) {
          FactoryGirl.create(:unpublished_story_in_published_category)
        }

        it "excludes story from resolved scope" do
          expect(resolved_scope).not_to include(story)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing stories in an unpublished category" do
      context "accessing a published music rack" do
        let(:story) {
          FactoryGirl.create(:published_story_in_unpublished_category)
        }

        it "excludes story from resolved scope" do
          expect(resolved_scope).not_to include(story)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished story" do
        let(:story) {
          FactoryGirl.create(:unpublished_story_in_unpublished_category)
        }

        it "excludes story from resolved scope" do
          expect(resolved_scope).not_to include(story)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end

  context "being a contributor" do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor, 
        contributor_profile: contributor_profile
      )
    }

    context "accessing stories in a published category" do
      context "accessing stories that the user does not contribute to" do
        context "accessing a published story" do
          let(:story) {
            FactoryGirl.create(:published_story_in_published_category)
          }

          it "includes story in resolved scope" do
            expect(resolved_scope).to include(story)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished story" do
          let(:story) {
            FactoryGirl.create(:unpublished_story_in_published_category)
          }

          it "excludes story from resolved scope" do
            expect(resolved_scope).not_to include(story)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing stories the user contributes to" do
        context "accessing a published story" do
          let(:story) {
            FactoryGirl.create(
              :published_story_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes story in resolved scope" do
            expect(resolved_scope).to include(story)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished story" do
          let(:story) {
            FactoryGirl.create(
              :unpublished_story_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes story in resolved scope" do
            expect(resolved_scope).to include(story)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end

    context "accessing stories in an unpublished category" do
      context "accessing stories that the user does not contribute to" do
        context "accessing a published story" do
          let(:story) {
            FactoryGirl.create(:published_story_in_published_category)
          }

          it "includes story in resolved scope" do
            expect(resolved_scope).to include(story)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished story" do
          let(:story) {
            FactoryGirl.create(:unpublished_story_in_published_category) 
          }

          it "excludes story from resolved scope" do
            expect(resolved_scope).not_to include(story)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing stories that the user contributes to" do
        context "accessing an published story" do
          let(:story) {
            FactoryGirl.create(
              :published_story_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes story in resolved scope" do
            expect(resolved_scope).to include(story)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished story" do
          let(:story) {
            FactoryGirl.create(
              :unpublished_story_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes story in resolved scope" do
            expect(resolved_scope).to include(story)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing stories in a published category" do
      context "accessing a published story" do
        let(:story) {
          FactoryGirl.create(:published_story_in_published_category)
        }

        it "includes story in resolved scope" do
          expect(resolved_scope).to include(story)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished story" do
        let(:story) {
          FactoryGirl.create(:unpublished_story_in_published_category)
        }

        it "includes story in resolved scope" do
          expect(resolved_scope).to include(story)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end

    context "accessing stories in an unpublished category" do
      context "accessing a published story" do
        let(:story) {
          FactoryGirl.create(:published_story_in_unpublished_category)
        }

        it "includes story in resolved scope" do
          expect(resolved_scope).to include(story)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished story" do
        let(:story) {
          FactoryGirl.create(:unpublished_story_in_unpublished_category)
        }

        it "includes story in resolved scope" do
          expect(resolved_scope).to include(story)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end
  end
end
