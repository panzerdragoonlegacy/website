require 'rails_helper'

describe NewsEntryPolicy do
  subject { described_class.new(user, news_entry) }

  let(:resolved_scope) do
    described_class::Scope.new(user, NewsEntry.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published news entry' do
      let(:news_entry) { FactoryGirl.create(:published_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished news entry' do
      let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

      it 'excludes news entry from resolved scope' do
        expect(resolved_scope).not_to include(news_entry)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published news entry' do
      let(:news_entry) { FactoryGirl.create(:published_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished news entry' do
      let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

      it 'excludes news entry from resolved scope' do
        expect(resolved_scope).not_to include(news_entry)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
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

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing news entries that the user does not contribute to' do
      context 'accessing a published news entry' do
        let(:news_entry) { FactoryGirl.create(:published_news_entry) }

        it 'includes news entry in resolved scope' do
          expect(resolved_scope).to include(news_entry)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished news entry' do
        let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

        it 'excludes news entry from resolved scope' do
          expect(resolved_scope).not_to include(news_entry)
        end

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing news entries the user contributes to' do
      context 'accessing a published news entry' do
        let(:news_entry) do
          FactoryGirl.create(
            :published_news_entry,
            contributor_profile: contributor_profile
          )
        end

        it 'includes news entry in resolved scope' do
          expect(resolved_scope).to include(news_entry)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_edit_and_update_actions }
        it { is_expected.to forbid_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished news entry' do
        let(:news_entry) do
          FactoryGirl.create(
            :unpublished_news_entry,
            contributor_profile_id: contributor_profile.id
          )
        end

        it 'includes news entry in resolved scope' do
          expect(resolved_scope).to include(news_entry)
        end

        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_edit_and_update_actions }
        it { is_expected.to permit_action(:destroy) }
        it { is_expected.to forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing a published news entry' do
      let(:news_entry) { FactoryGirl.create(:published_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished news entry' do
      let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
