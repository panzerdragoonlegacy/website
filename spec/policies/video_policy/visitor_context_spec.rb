require 'rails_helper'

describe VideoPolicy do
  subject { described_class.new(user, video) }

  let(:resolved_scope) { described_class::Scope.new(user, Video.all).resolve }

  let(:user) { nil }

  context 'visitor creating a new video' do
    let(:video) { Video.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'visitor accessing videos in a published category' do
    context 'accessing a published video' do
      let(:video) { FactoryBot.create(:published_video_in_published_category) }

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished video' do
      let(:video) do
        FactoryBot.create(:unpublished_video_in_published_category)
      end

      it 'excludes video from resolved scope' do
        expect(resolved_scope).not_to include(video)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'visitor accessing videos in an unpublished category' do
    context 'accessing a published video' do
      let(:video) do
        FactoryBot.create(:published_video_in_unpublished_category)
      end

      it 'excludes video from resolved scope' do
        expect(resolved_scope).not_to include(video)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished video' do
      let(:video) do
        FactoryBot.create(:unpublished_video_in_unpublished_category)
      end

      it 'excludes video from resolved scope' do
        expect(resolved_scope).not_to include(video)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
