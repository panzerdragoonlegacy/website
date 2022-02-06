require 'rails_helper'

describe NewsEntryPolicy do
  subject { described_class.new(user, news_entry) }

  let(:resolved_scope) do
    described_class::Scope.new(user, NewsEntry.all).resolve
  end

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user creating a new news entry' do
    let(:news_entry) { NewsEntry.new }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
    it { is_expected.to forbid_mass_assignment_of(:contributor_profile_id) }
  end

  context 'registered user accessing a published news entry' do
    let(:news_entry) { FactoryBot.create(:published_news_entry) }

    it 'includes news entry in resolved scope' do
      expect(resolved_scope).to include(news_entry)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
    it { is_expected.to forbid_mass_assignment_of(:contributor_profile_id) }
  end

  context 'registered user accessing an unpublished news entry' do
    let(:news_entry) { FactoryBot.create(:unpublished_news_entry) }

    it 'excludes news entry from resolved scope' do
      expect(resolved_scope).not_to include(news_entry)
    end

    it { is_expected.to forbid_actions(%i[show edit update destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
    it { is_expected.to forbid_mass_assignment_of(:contributor_profile_id) }
  end
end
