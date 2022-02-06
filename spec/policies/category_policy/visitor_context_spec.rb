require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  let(:user) { nil }

  context 'visitor accessing a published category' do
    let(:category) { FactoryBot.create(:published_category) }

    it 'includes category in resolved scope' do
      expect(resolved_scope).to include(category)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[new create edit update destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'visitor accessing an unpublished category' do
    let(:category) { FactoryBot.create(:unpublished_category) }

    it 'excludes category from resolved scope' do
      expect(resolved_scope).not_to include(category)
    end

    it do
      is_expected.to forbid_actions(%i[show new create edit update destroy])
    end
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'visitor is accessing a parent category' do
    let(:category) { FactoryBot.create(:valid_parent_category) }

    it { is_expected.to forbid_action(:destroy) }
  end
end
