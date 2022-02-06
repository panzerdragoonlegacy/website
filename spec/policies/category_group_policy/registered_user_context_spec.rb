require 'rails_helper'

describe CategoryGroupPolicy do
  subject { described_class.new(user, category_group) }

  let(:resolved_scope) do
    described_class::Scope.new(user, CategoryGroup.all).resolve
  end

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user accessing a category group' do
    let(:category_group) { FactoryBot.create(:valid_category_group) }

    it 'includes category group in resolved scope' do
      expect(resolved_scope).to include(category_group)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[new create edit update destroy]) }
  end
end
