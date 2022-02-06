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
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing music tracks in a published category' do
    context 'accessing a published music track' do
      let(:music_track) do
        FactoryBot.create(:published_music_track_in_published_category)
      end

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished music track' do
      let(:music_track) do
        FactoryBot.create(:unpublished_music_track_in_published_category)
      end

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing music tracks in an unpublished category' do
    context 'accessing a published music track' do
      let(:music_track) do
        FactoryBot.create(:published_music_track_in_unpublished_category)
      end

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished music track' do
      let(:music_track) do
        FactoryBot.create(:unpublished_music_track_in_unpublished_category)
      end

      it 'includes music track in resolved scope' do
        expect(resolved_scope).to include(music_track)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
