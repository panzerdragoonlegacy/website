require 'rails_helper'

describe PagePolicy do
  subject { described_class.new(user, page) }

  let(:resolved_scope) { described_class::Scope.new(user, Page.all).resolve }

  let(:contributor_profile) { FactoryBot.create(:valid_contributor_profile) }
  let(:user) do
    FactoryBot.create(:contributor, contributor_profile: contributor_profile)
  end

  context 'contributor creating a new page' do
    let(:page) { Page.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'contributor accessing pages that they do not contribute to' do
    context 'accessing a published page' do
      let(:page) { FactoryBot.create(:published_page) }

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) { FactoryBot.create(:unpublished_page) }

      it 'excludes page from resolved scope' do
        expect(resolved_scope).not_to include(page)
      end

      it { is_expected.to forbid_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end

  context 'contributor accessing pages that they contribute to' do
    context 'accessing a published page' do
      let(:page) do
        FactoryBot.create(
          :published_page,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_actions(%i[edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end

    context 'accessing an unpublished page' do
      let(:page) do
        FactoryBot.create(
          :unpublished_page,
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        )
      end

      it 'includes page in resolved scope' do
        expect(resolved_scope).to include(page)
      end

      it { is_expected.to permit_actions(%i[show edit update destroy]) }
      it { is_expected.to forbid_attribute(:publish) }
    end
  end
end
