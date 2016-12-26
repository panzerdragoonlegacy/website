require 'rails_helper'

describe CategoryGroupPolicy do
  subject { described_class.new(user, category_group) }

  let(:resolved_scope) do
    described_class::Scope.new(user, CategoryGroup.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing a category group' do
      let(:category_group) do
        FactoryGirl.create(:valid_category_group)
      end

      it 'includes category group in resolved scope' do
        expect(resolved_scope).to include(category_group)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
