require 'rails_helper'

describe VideoPolicy do
  subject { described_class.new(user, video) }

  let(:resolved_scope) { described_class::Scope.new(user, Video.all).resolve }

  let(:user) { nil }

  context 'visitor creating a new video' do
    let(:video) { Video.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'visitor accessing a published video' do
    let(:video) { FactoryBot.create(:published_video) }

    it 'includes video in resolved scope' do
      expect(resolved_scope).to include(video)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'visitor accessing an unpublished video' do
    let(:video) { FactoryBot.create(:unpublished_video) }

    it 'excludes video from resolved scope' do
      expect(resolved_scope).not_to include(video)
    end

    it { is_expected.to forbid_actions(%i[show edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end
end
