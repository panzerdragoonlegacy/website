require 'rails_helper'

describe MusicTrackPolicy do
  subject { described_class.new(user, music_track) }

  let(:resolved_scope) do
    described_class::Scope.new(user, MusicTrack.all).resolve
  end

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new music track' do
    let(:music_track) { MusicTrack.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'contributor accessing music tracks that they do not contribute to' do
    context 'accessing a published music track' do
      let(:music_track) { FactoryBot.create(:published_music_track) }

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished music track' do
      let(:music_track) { FactoryBot.create(:unpublished_music_track) }

      it 'excludes music track from resolved scope' do
        expect(resolved_scope).not_to include(music_track)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end

  context 'contributor accessing music tracks that they contribute to' do
    context 'accessing a published music track' do
      let(:music_track) do
        FactoryBot.create(
          :published_music_track,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished music track' do
      let(:music_track) do
        FactoryBot.create(
          :unpublished_music_track,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end
end
