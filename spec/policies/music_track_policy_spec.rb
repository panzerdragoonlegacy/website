require 'rails_helper'

describe MusicTrackPolicy do
  subject { described_class.new(user, music_track) }

  let(:resolved_scope) do
    described_class::Scope.new(user, MusicTrack.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new music track' do
      let(:music_track) { MusicTrack.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing music tracks in a published category' do
      context 'accessing a published music track' do
        let(:music_track) do
          FactoryGirl.create(:published_music_track_in_published_category)
        end

        it 'includes music track in resolved scope' do
          expect(resolved_scope).to include(music_track)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished music track' do
        let(:music_track) do
          FactoryGirl.create(:unpublished_music_track_in_published_category)
        end

        it 'excludes music track from resolved scope' do
          expect(resolved_scope).not_to include(music_track)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing music tracks in an unpublished category' do
      context 'accessing a published music track' do
        let(:music_track) do
          FactoryGirl.create(:published_music_track_in_unpublished_category)
        end

        it 'excludes music track from resolved scope' do
          expect(resolved_scope).not_to include(music_track)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished music track' do
        let(:music_track) do
          FactoryGirl.create(:unpublished_music_track_in_unpublished_category)
        end

        it 'excludes music track from resolved scope' do
          expect(resolved_scope).not_to include(music_track)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'creating a new music track' do
      let(:music_track) { MusicTrack.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing music tracks in a published category' do
      context 'accessing a published music track' do
        let(:music_track) do
          FactoryGirl.create(:published_music_track_in_published_category)
        end

        it 'includes music track in resolved scope' do
          expect(resolved_scope).to include(music_track)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished music track' do
        let(:music_track) do
          FactoryGirl.create(:unpublished_music_track_in_published_category)
        end

        it 'excludes music track from resolved scope' do
          expect(resolved_scope).not_to include(music_track)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing music tracks in an unpublished category' do
      context 'accessing a published music track' do
        let(:music_track) do
          FactoryGirl.create(:published_music_track_in_unpublished_category)
        end

        it 'excludes music track from resolved scope' do
          expect(resolved_scope).not_to include(music_track)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished music track' do
        let(:music_track) do
          FactoryGirl.create(:unpublished_music_track_in_unpublished_category)
        end

        it 'excludes music track from resolved scope' do
          expect(resolved_scope).not_to include(music_track)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
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

    context 'creating a new music track' do
      let(:music_track) { MusicTrack.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing music tracks in a published category' do
      context 'accessing music tracks that the user does not contribute to' do
        context 'accessing a published music track' do
          let(:music_track) do
            FactoryGirl.create(:published_music_track_in_published_category)
          end

          it 'includes music track in resolved scope' do
            expect(resolved_scope).to include(music_track)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished music track' do
          let(:music_track) do
            FactoryGirl.create(:unpublished_music_track_in_published_category)
          end

          it 'excludes music track from resolved scope' do
            expect(resolved_scope).not_to include(music_track)
          end

          it { is_expected.to forbid_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing music tracks the user contributes to' do
        context 'accessing a published music track' do
          let(:music_track) do
            FactoryGirl.create(
              :published_music_track_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes music track in resolved scope' do
            expect(resolved_scope).to include(music_track)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished music track' do
          let(:music_track) do
            FactoryGirl.create(
              :unpublished_music_track_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes music track in resolved scope' do
            expect(resolved_scope).to include(music_track)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to permit_edit_and_update_actions }
          it { is_expected.to permit_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context 'accessing music tracks in an unpublished category' do
      context 'accessing music tracks that the user does not contribute to' do
        context 'accessing a published music track' do
          let(:music_track) do
            FactoryGirl.create(:published_music_track_in_published_category)
          end

          it 'includes music track in resolved scope' do
            expect(resolved_scope).to include(music_track)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished music track' do
          let(:music_track) do
            FactoryGirl.create(:unpublished_music_track_in_published_category)
          end

          it 'excludes music track from resolved scope' do
            expect(resolved_scope).not_to include(music_track)
          end

          it { is_expected.to forbid_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing music tracks that the user contributes to' do
        context 'accessing a published music track' do
          let(:music_track) do
            FactoryGirl.create(
              :published_music_track_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes music track in resolved scope' do
            expect(resolved_scope).to include(music_track)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished music track' do
          let(:music_track) do
            FactoryGirl.create(
              :unpublished_music_track_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes music track in resolved scope' do
            expect(resolved_scope).to include(music_track)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to permit_edit_and_update_actions }
          it { is_expected.to permit_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new music track' do
      let(:music_track) { MusicTrack.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing music tracks in a published category' do
      context 'accessing a published music track' do
        let(:music_track) do
          FactoryGirl.create(:published_music_track_in_published_category)
        end

        it 'includes music track in resolved scope' do
          expect(resolved_scope).to include(music_track)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished music track' do
        let(:music_track) do
          FactoryGirl.create(:unpublished_music_track_in_published_category)
        end

        it 'includes music track in resolved scope' do
          expect(resolved_scope).to include(music_track)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end
    end

    context 'accessing music tracks in an unpublished category' do
      context 'accessing a published music track' do
        let(:music_track) do
          FactoryGirl.create(:published_music_track_in_unpublished_category)
        end

        it 'includes music track in resolved scope' do
          expect(resolved_scope).to include(music_track)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished music track' do
        let(:music_track) do
          FactoryGirl.create(:unpublished_music_track_in_unpublished_category)
        end

        it 'includes music track in resolved scope' do
          expect(resolved_scope).to include(music_track)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to permit_mass_assignment_of(:publish) }
      end
    end
  end
end
