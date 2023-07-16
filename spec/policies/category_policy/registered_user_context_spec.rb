require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user accessing a published category' do
    let(:category) { FactoryBot.create(:published_category) }

    it 'includes category in resolved scope' do
      expect(resolved_scope).to include(category)
    end

    it { is_expected.to permit_only_actions(:show) }
    it { is_expected.to forbid_actions(%i[new create edit update destroy]) }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'registered user accessing an unpublished category' do
    let(:category) { FactoryBot.create(:unpublished_category) }

    it 'excludes category from resolved scope' do
      expect(resolved_scope).not_to include(category)
    end

    it { is_expected.to forbid_all_actions }
    it { is_expected.to forbid_attribute(:publish) }
  end

  context 'registered user is accessing a parent category' do
    let(:category) { FactoryBot.create(:valid_parent_category) }

    it { is_expected.to forbid_all_actions }
    it { is_expected.to forbid_action(:destroy) }

    context 'category has subcategories' do
      before do
        category.categorisations << FactoryBot.create(:valid_categorisation)
      end

      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
