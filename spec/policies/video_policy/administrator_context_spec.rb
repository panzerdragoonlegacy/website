require 'rails_helper'

describe VideoPolicy do
  subject { described_class.new(user, video) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Video.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'creating a new video' do
    let(:video) { Video.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing videos in a published category' do
    context 'accessing a published video' do
      let(:video) do
        FactoryGirl.create(:published_video_in_published_category)
      end

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished video' do
      let(:video) do
        FactoryGirl.create(:unpublished_video_in_published_category)
      end

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing videos in an unpublished category' do
    context 'accessing a published video' do
      let(:video) do
        FactoryGirl.create(:published_video_in_unpublished_category)
      end

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished video' do
      let(:video) do
        FactoryGirl.create(:unpublished_video_in_unpublished_category)
      end

      it 'includes video in resolved scope' do
        expect(resolved_scope).to include(video)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
