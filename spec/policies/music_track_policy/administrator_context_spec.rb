require 'rails_helper'

describe MusicTrackPolicy do
  subject { described_class.new(user, music_track) }

  let(:resolved_scope) do
    described_class::Scope.new(user, MusicTrack.all).resolve
  end

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new music track' do
    let(:music_track) { MusicTrack.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_attribute(:publish) }
  end

  context 'administrator accessing a published music track' do
    let(:music_track) { FactoryBot.create(:published_music_track) }

    it 'includes music track in resolved scope' do
      expect(resolved_scope).to include(music_track)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_attribute(:publish) }
  end

  context 'administrator accessing an unpublished music track' do
    let(:music_track) { FactoryBot.create(:unpublished_music_track) }

    it 'includes music track in resolved scope' do
      expect(resolved_scope).to include(music_track)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_attribute(:publish) }
  end
end
