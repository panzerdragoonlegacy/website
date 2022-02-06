require 'rails_helper'

describe NewsEntryPolicy do
  subject { described_class.new(user, news_entry) }

  let(:resolved_scope) do
    described_class::Scope.new(user, NewsEntry.all).resolve
  end

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new news entry' do
    let(:news_entry) { NewsEntry.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
    it { is_expected.to permit_mass_assignment_of(:contributor_profile_id) }
  end

  context 'administrator accessing a published news entry' do
    let(:news_entry) { FactoryBot.create(:published_news_entry) }

    it 'includes news entry in resolved scope' do
      expect(resolved_scope).to include(news_entry)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
    it { is_expected.to permit_mass_assignment_of(:contributor_profile_id) }
  end

  context 'administrator accessing an unpublished news entry' do
    let(:news_entry) { FactoryBot.create(:unpublished_news_entry) }

    it 'includes news entry in resolved scope' do
      expect(resolved_scope).to include(news_entry)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
    it { is_expected.to permit_mass_assignment_of(:contributor_profile_id) }
  end
end
