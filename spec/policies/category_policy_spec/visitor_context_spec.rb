require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing a published category' do
      let(:category) do
        FactoryGirl.create(:published_category)
      end

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished category' do
      let(:category) do
        FactoryGirl.create(:unpublished_category)
      end

      it 'excludes category from resolved scope' do
        expect(resolved_scope).not_to include(category)
      end

      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end
  end
end
