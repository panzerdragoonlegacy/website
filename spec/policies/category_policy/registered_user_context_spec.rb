require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'accessing a published category' do
      let(:category) do
        FactoryGirl.create(:published_category)
      end

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { is_expected.to permit_action(:show) }
      it do
        is_expected.to forbid_actions([:new, :create, :edit, :update, :destroy])
      end
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished category' do
      let(:category) do
        FactoryGirl.create(:unpublished_category)
      end

      it 'excludes category from resolved scope' do
        expect(resolved_scope).not_to include(category)
      end

      it do
        is_expected.to forbid_actions([:show, :new, :create, :edit, :update])
      end
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
