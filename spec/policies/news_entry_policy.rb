require 'rails_helper'

describe NewsEntryPolicy do
  subject { NewsEntryPolicy.new(user, news_entry) }

  let(:resolved_scope) {
    NewsEntryPolicy::Scope.new(user, NewsEntry.all).resolve
  }

  context 'being a visitor' do
    let(:user) { nil }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { should forbid_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published news entry' do
      let(:news_entry) { FactoryGirl.create(:published_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished news entry' do
      let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

      it 'excludes news entry from resolved scope' do
        expect(resolved_scope).not_to include(news_entry)
      end

      it { should forbid_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { should forbid_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing a published news entry' do
      let(:news_entry) { FactoryGirl.create(:published_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished news entry' do
      let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

      it 'excludes news entry from resolved scope' do
        expect(resolved_scope).not_to include(news_entry)
      end

      it { should forbid_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being a contributor' do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor,
        contributor_profile: contributor_profile
      )
    }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { should permit_new_and_create_actions }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing news entries that the user does not contribute to' do
      context 'accessing a published news entry' do
        let(:news_entry) { FactoryGirl.create(:published_news_entry) }

        it 'includes news entry in resolved scope' do
          expect(resolved_scope).to include(news_entry)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished news entry' do
        let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

        it 'excludes news entry from resolved scope' do
          expect(resolved_scope).not_to include(news_entry)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing news entries the user contributes to' do
      context 'accessing a published news entry' do
        let(:news_entry) {
          FactoryGirl.create(
            :published_news_entry,
            contributor_profile: contributor_profile
          )
        }

        it 'includes news entry in resolved scope' do
          expect(resolved_scope).to include(news_entry)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished news entry' do
        let(:news_entry) {
          FactoryGirl.create(
            :unpublished_news_entry,
            contributor_profile_id: contributor_profile.id
          )
        }

        it 'includes news entry in resolved scope' do
          expect(resolved_scope).to include(news_entry)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'creating a new news entry' do
      let(:news_entry) { NewsEntry.new }

      it { should permit_new_and_create_actions }
      it { should permit_mass_assignment_of(:publish) }
    end

    context 'accessing a published news entry' do
      let(:news_entry) { FactoryGirl.create(:published_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished news entry' do
      let(:news_entry) { FactoryGirl.create(:unpublished_news_entry) }

      it 'includes news entry in resolved scope' do
        expect(resolved_scope).to include(news_entry)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:publish) }
    end
  end
end
