require 'rails_helper'

describe MusicTrackPolicy do
  subject { described_class.new(user, music_track) }

  let(:resolved_scope) do
    described_class::Scope.new(user, MusicTrack.all).resolve
  end

  let(:user) { nil }

  context 'visitor creating a new music track' do
    let(:music_track) { MusicTrack.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'visitor accessing a published music track' do
    let(:music_track) { FactoryBot.create(:published_music_track) }

    it 'includes music track in resolved scope' do
      expect(resolved_scope).to include(music_track)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'visitor accessing an unpublished music track' do
    let(:music_track) { FactoryBot.create(:unpublished_music_track) }

    it 'excludes music track from resolved scope' do
      expect(resolved_scope).not_to include(music_track)
    end

    it { is_expected.to forbid_actions(%i[show edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end
end
