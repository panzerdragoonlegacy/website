require 'rails_helper'

describe VideoPolicy do
  subject { described_class.new(user, video) }

  let(:resolved_scope) { described_class::Scope.new(user, Video.all).resolve }

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new video' do
    let(:video) { Video.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'contributor accessing videos they do not contribute to' do
    context 'accessing a published video' do
      let(:video) { FactoryBot.create(:published_video) }

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished video' do
      let(:video) { FactoryBot.create(:unpublished_video) }

      it 'excludes video from resolved scope' do
        expect(resolved_scope).not_to include(video)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end

  context 'contributor accessing videos that they contribute to' do
    context 'accessing a published video' do
      let(:video) do
        FactoryBot.create(
          :published_video,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished video' do
      let(:video) do
        FactoryBot.create(
          :unpublished_video,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end
end
