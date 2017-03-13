require 'rails_helper'

describe CategoryGroupPolicy do
  subject { described_class.new(user, category_group) }

  let(:resolved_scope) do
    described_class::Scope.new(user, CategoryGroup.all).resolve
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing a category group' do
      let(:category_group) do
        FactoryGirl.create(:valid_category_group)
      end

      it 'includes category group in resolved scope' do
        expect(resolved_scope).to include(category_group)
      end

      it do
        is_expected.to permit_actions([:show, :new, :create, :edit, :update])
      end

      context 'category group has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'category group has children' do
        before do
          category_group.categories << FactoryGirl.create(:valid_category)
        end

        it { is_expected.to forbid_action(:destroy) }
      end
    end
  end
end
