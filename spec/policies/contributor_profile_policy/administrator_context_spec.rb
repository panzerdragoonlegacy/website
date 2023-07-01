require 'rails_helper'

describe ContributorProfilePolicy do
  subject { described_class.new(user, contributor_profile) }

  let(:resolved_scope) do
    described_class::Scope.new(user, ContributorProfile.all).resolve
  end

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator creating a new contributor profile' do
    let(:contributor_profile) { ContributorProfile.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_attribute(:publish) }
  end

  context 'administrator accessing a published contributor profile' do
    let(:contributor_profile) do
      FactoryBot.create(:published_contributor_profile)
    end

    it 'includes contributor profile in resolved scope' do
      expect(resolved_scope).to include(contributor_profile)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_attribute(:publish) }
  end

  context 'administrator accessing an unpublished contributor profile' do
    let(:contributor_profile) do
      FactoryBot.create(:unpublished_contributor_profile)
    end

    it 'includes contributor profile in resolved scope' do
      expect(resolved_scope).to include(contributor_profile)
    end

    it { is_expected.to permit_actions(%i[show edit update destroy]) }
    it { is_expected.to permit_attribute(:publish) }
  end
end
