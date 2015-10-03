require 'rails_helper'

describe VideoPolicy do
  subject { VideoPolicy.new(user, video) }

  let(:resolved_scope) {
    VideoPolicy::Scope.new(user, Video.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing videos in a published category" do
      context "accessing a published video" do
        let(:video) {
          FactoryGirl.create(:published_video_in_published_category)
        }

        it "includes video in resolved scope" do
          expect(resolved_scope).to include(video)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished video" do
        let(:video) {
          FactoryGirl.create(:unpublished_video_in_published_category)
        }

        it "excludes video from resolved scope" do
          expect(resolved_scope).not_to include(video)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
    
    context "accessing videos in an unpublished category" do
      context "accessing a published video" do
        let(:video) {
          FactoryGirl.create(:published_video_in_unpublished_category)
        }

        it "excludes video from resolved scope" do
          expect(resolved_scope).not_to include(video)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished video" do
        let(:video) {
          FactoryGirl.create(:unpublished_video_in_unpublished_category)
        }

        it "excludes video from resolved scope" do
          expect(resolved_scope).not_to include(video)
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

    context "accessing videos in a published category" do
      context "accessing a published video" do
        let(:video) {
          FactoryGirl.create(:published_video_in_published_category)
        }

        it "includes video in resolved scope" do
          expect(resolved_scope).to include(video)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished video" do
        let(:video) {
          FactoryGirl.create(:unpublished_video_in_published_category)
        }

        it "excludes video from resolved scope" do
          expect(resolved_scope).not_to include(video)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing videos in an unpublished category" do
      context "accessing a published music rack" do
        let(:video) {
          FactoryGirl.create(:published_video_in_unpublished_category)
        }

        it "excludes video from resolved scope" do
          expect(resolved_scope).not_to include(video)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished video" do
        let(:video) {
          FactoryGirl.create(:unpublished_video_in_unpublished_category)
        }

        it "excludes video from resolved scope" do
          expect(resolved_scope).not_to include(video)
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

    context "accessing videos in a published category" do
      context "accessing videos that the user does not contribute to" do
        context "accessing a published video" do
          let(:video) {
            FactoryGirl.create(:published_video_in_published_category)
          }

          it "includes video in resolved scope" do
            expect(resolved_scope).to include(video)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished video" do
          let(:video) {
            FactoryGirl.create(:unpublished_video_in_published_category)
          }

          it "excludes video from resolved scope" do
            expect(resolved_scope).not_to include(video)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing videos the user contributes to" do
        context "accessing a published video" do
          let(:video) {
            FactoryGirl.create(
              :published_video_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes video in resolved scope" do
            expect(resolved_scope).to include(video)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished video" do
          let(:video) {
            FactoryGirl.create(
              :unpublished_video_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes video in resolved scope" do
            expect(resolved_scope).to include(video)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end

    context "accessing videos in an unpublished category" do
      context "accessing videos that the user does not contribute to" do
        context "accessing a published video" do
          let(:video) {
            FactoryGirl.create(:published_video_in_published_category)
          }

          it "includes video in resolved scope" do
            expect(resolved_scope).to include(video)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished video" do
          let(:video) {
            FactoryGirl.create(:unpublished_video_in_published_category) 
          }

          it "excludes video from resolved scope" do
            expect(resolved_scope).not_to include(video)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing videos that the user contributes to" do
        context "accessing a published video" do
          let(:video) {
            FactoryGirl.create(
              :published_video_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes video in resolved scope" do
            expect(resolved_scope).to include(video)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished video" do
          let(:video) {
            FactoryGirl.create(
              :unpublished_video_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes video in resolved scope" do
            expect(resolved_scope).to include(video)
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

    context "accessing videos in a published category" do
      context "accessing a published video" do
        let(:video) {
          FactoryGirl.create(:published_video_in_published_category)
        }

        it "includes video in resolved scope" do
          expect(resolved_scope).to include(video)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished video" do
        let(:video) {
          FactoryGirl.create(:unpublished_video_in_published_category)
        }

        it "includes video in resolved scope" do
          expect(resolved_scope).to include(video)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end

    context "accessing videos in an unpublished category" do
      context "accessing a published video" do
        let(:video) {
          FactoryGirl.create(:published_video_in_unpublished_category)
        }

        it "includes video in resolved scope" do
          expect(resolved_scope).to include(video)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished video" do
        let(:video) {
          FactoryGirl.create(:unpublished_video_in_unpublished_category)
        }

        it "includes video in resolved scope" do
          expect(resolved_scope).to include(video)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end
  end
end
