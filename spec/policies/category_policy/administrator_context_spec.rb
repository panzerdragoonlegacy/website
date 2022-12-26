require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  let(:user) { FactoryBot.create(:administrator) }

  context 'administrator accessing a published category' do
    let(:category) { FactoryBot.create(:published_picture_category) }

    it 'includes category in resolved scope' do
      expect(resolved_scope).to include(category)
    end

    it { is_expected.to permit_actions(%i[show new create edit update]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }

    context 'category has no children' do
      it { is_expected.to permit_action(:destroy) }
    end

    context 'category has children' do
      before do
        category.pictures << FactoryBot.create(:published_picture)
      end

      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'administrator accessing an unpublished category' do
    let(:category) { FactoryBot.create(:unpublished_picture_category) }

    it 'includes category in resolved scope' do
      expect(resolved_scope).to include(category)
    end

    it { is_expected.to permit_actions(%i[show new create edit update]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }

    context 'category has no children' do
      it { is_expected.to permit_action(:destroy) }
    end

    context 'category has children' do
      before do
        category.pictures << FactoryBot.create(:published_picture)
      end

      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'administrator is accessing a parent category' do
    let(:category) { FactoryBot.create(:valid_parent_category) }

    it { is_expected.to permit_action(:destroy) }

    context 'category has subcategories' do
      before do
        category.categorisations << FactoryBot.create(:valid_categorisation)
      end

      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
