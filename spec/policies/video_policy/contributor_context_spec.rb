require 'rails_helper'

describe VideoPolicy do
  subject { described_class.new(user, video) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Video.all).resolve
  end

  let(:contributor_profile) do
    FactoryGirl.create(:valid_contributor_profile)
  end
  let(:user) do
    FactoryGirl.create(
      :contributor,
      contributor_profile: contributor_profile
    )
  end

  context 'contributor creating a new video' do
    let(:video) { Video.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'contributor accessing videos in a published category' do
    context 'accessing videos that the user does not contribute to' do
      context 'accessing a published video' do
        let(:video) do
          FactoryGirl.create(:published_video_in_published_category)
        end

        it 'includes video in resolved scope' do
          expect(resolved_scope).to include(video)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished video' do
        let(:video) do
          FactoryGirl.create(:unpublished_video_in_published_category)
        end

        it 'excludes video from resolved scope' do
          expect(resolved_scope).not_to include(video)
        end

        it do
          is_expected.to forbid_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing videos the user contributes to' do
      context 'accessing a published video' do
        let(:video) do
          FactoryGirl.create(
            :published_video_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes video in resolved scope' do
          expect(resolved_scope).to include(video)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished video' do
        let(:video) do
          FactoryGirl.create(
            :unpublished_video_in_published_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes video in resolved scope' do
          expect(resolved_scope).to include(video)
        end

        it do
          is_expected.to permit_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'contributor accessing videos in an unpublished category' do
    context 'accessing videos that the user does not contribute to' do
      context 'accessing a published video' do
        let(:video) do
          FactoryGirl.create(:published_video_in_published_category)
        end

        it 'includes video in resolved scope' do
          expect(resolved_scope).to include(video)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished video' do
        let(:video) do
          FactoryGirl.create(:unpublished_video_in_published_category)
        end

        it 'excludes video from resolved scope' do
          expect(resolved_scope).not_to include(video)
        end

        it do
          is_expected.to forbid_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing videos that the user contributes to' do
      context 'accessing a published video' do
        let(:video) do
          FactoryGirl.create(
            :published_video_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes video in resolved scope' do
          expect(resolved_scope).to include(video)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished video' do
        let(:video) do
          FactoryGirl.create(
            :unpublished_video_in_unpublished_category,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        end

        it 'includes video in resolved scope' do
          expect(resolved_scope).to include(video)
        end

        it do
          is_expected.to permit_actions([:show, :edit, :update, :destroy])
        end
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end
end
