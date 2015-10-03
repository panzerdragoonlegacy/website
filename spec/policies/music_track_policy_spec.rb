require 'rails_helper'

describe MusicTrackPolicy do
  subject { MusicTrackPolicy.new(user, music_track) }

  let(:resolved_scope) {
    MusicTrackPolicy::Scope.new(user, MusicTrack.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing music tracks in a published category" do
      context "accessing a published music track" do
        let(:music_track) {
          FactoryGirl.create(:published_music_track_in_published_category)
        }

        it "includes music track in resolved scope" do
          expect(resolved_scope).to include(music_track)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished music track" do
        let(:music_track) {
          FactoryGirl.create(:unpublished_music_track_in_published_category)
        }

        it "excludes music track from resolved scope" do
          expect(resolved_scope).not_to include(music_track)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
    
    context "accessing music tracks in an unpublished category" do
      context "accessing a published music track" do
        let(:music_track) {
          FactoryGirl.create(:published_music_track_in_unpublished_category)
        }

        it "excludes music track from resolved scope" do
          expect(resolved_scope).not_to include(music_track)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished music track" do
        let(:music_track) {
          FactoryGirl.create(:unpublished_music_track_in_unpublished_category)
        }

        it "excludes music track from resolved scope" do
          expect(resolved_scope).not_to include(music_track)
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

    context "accessing music tracks in a published category" do
      context "accessing a published music track" do
        let(:music_track) {
          FactoryGirl.create(:published_music_track_in_published_category)
        }

        it "includes music track in resolved scope" do
          expect(resolved_scope).to include(music_track)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished music track" do
        let(:music_track) {
          FactoryGirl.create(:unpublished_music_track_in_published_category)
        }

        it "excludes music track from resolved scope" do
          expect(resolved_scope).not_to include(music_track)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing music tracks in an unpublished category" do
      context "accessing a published music rack" do
        let(:music_track) {
          FactoryGirl.create(:published_music_track_in_unpublished_category)
        }

        it "excludes music track from resolved scope" do
          expect(resolved_scope).not_to include(music_track)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing an unpublished music track" do
        let(:music_track) {
          FactoryGirl.create(:unpublished_music_track_in_unpublished_category)
        }

        it "excludes music track from resolved scope" do
          expect(resolved_scope).not_to include(music_track)
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

    context "accessing music tracks in a published category" do
      context "accessing music tracks that the user does not contribute to" do
        context "accessing a published music track" do
          let(:music_track) {
            FactoryGirl.create(:published_music_track_in_published_category)
          }

          it "includes music track in resolved scope" do
            expect(resolved_scope).to include(music_track)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished music track" do
          let(:music_track) {
            FactoryGirl.create(:unpublished_music_track_in_published_category)
          }

          it "excludes music track from resolved scope" do
            expect(resolved_scope).not_to include(music_track)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing music tracks the user contributes to" do
        context "accessing a published music track" do
          let(:music_track) {
            FactoryGirl.create(
              :published_music_track_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes music track in resolved scope" do
            expect(resolved_scope).to include(music_track)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished music track" do
          let(:music_track) {
            FactoryGirl.create(
              :unpublished_music_track_in_published_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes music track in resolved scope" do
            expect(resolved_scope).to include(music_track)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end
    end

    context "accessing music tracks in an unpublished category" do
      context "accessing music tracks that the user does not contribute to" do
        context "accessing a published music track" do
          let(:music_track) {
            FactoryGirl.create(:published_music_track_in_published_category)
          }

          it "includes music track in resolved scope" do
            expect(resolved_scope).to include(music_track)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished music track" do
          let(:music_track) {
            FactoryGirl.create(:unpublished_music_track_in_published_category) 
          }

          it "excludes music track from resolved scope" do
            expect(resolved_scope).not_to include(music_track)
          end

          it { should forbid_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end
      end

      context "accessing music tracks that the user contributes to" do
        context "accessing a published music track" do
          let(:music_track) {
            FactoryGirl.create(
              :published_music_track_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes music track in resolved scope" do
            expect(resolved_scope).to include(music_track)
          end

          it { should permit_action(:show) }
          it { should forbid_new_and_create }
          it { should forbid_edit_and_update }
          it { should forbid_action(:destroy) }
        end

        context "accessing an unpublished music track" do
          let(:music_track) {
            FactoryGirl.create(
              :unpublished_music_track_in_unpublished_category, 
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          }

          it "includes music track in resolved scope" do
            expect(resolved_scope).to include(music_track)
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

    context "accessing music tracks in a published category" do
      context "accessing a published music track" do
        let(:music_track) {
          FactoryGirl.create(:published_music_track_in_published_category)
        }

        it "includes music track in resolved scope" do
          expect(resolved_scope).to include(music_track)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished music track" do
        let(:music_track) {
          FactoryGirl.create(:unpublished_music_track_in_published_category)
        }

        it "includes music track in resolved scope" do
          expect(resolved_scope).to include(music_track)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end

    context "accessing music tracks in an unpublished category" do
      context "accessing a published music track" do
        let(:music_track) {
          FactoryGirl.create(:published_music_track_in_unpublished_category)
        }

        it "includes music track in resolved scope" do
          expect(resolved_scope).to include(music_track)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end

      context "accessing an unpublished music track" do
        let(:music_track) {
          FactoryGirl.create(:unpublished_music_track_in_unpublished_category)
        }

        it "includes music track in resolved scope" do
          expect(resolved_scope).to include(music_track)
        end

        it { should permit_action(:show) }
        it { should permit_new_and_create }
        it { should permit_edit_and_update }
        it { should permit_action(:destroy) }
      end
    end
  end
end
