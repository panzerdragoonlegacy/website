require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'administrator accessing a published category' do
    let(:category) { FactoryGirl.create(:published_picture_category) }

    it 'includes category in resolved scope' do
      expect(resolved_scope).to include(category)
    end

    it do
      is_expected.to permit_actions([:show, :new, :create, :edit, :update])
    end
    it { is_expected.to permit_mass_assignment_of(:publish) }

    context 'category has no children' do
      it { is_expected.to permit_action(:destroy) }
    end

    context 'category has children' do
      before do
        category.pictures << FactoryGirl.create(
          :published_picture_in_published_category
        )
      end

      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'administrator accessing an unpublished category' do
    let(:category) { FactoryGirl.create(:unpublished_picture_category) }

    it 'includes category in resolved scope' do
      expect(resolved_scope).to include(category)
    end

    it do
      is_expected.to permit_actions([:show, :new, :create, :edit, :update])
    end
    it { is_expected.to permit_mass_assignment_of(:publish) }

    context 'category has no children' do
      it { is_expected.to permit_action(:destroy) }
    end

    context 'category has children' do
      before do
        category.pictures << FactoryGirl.create(
          :published_picture_in_published_category
        )
      end

      it { is_expected.to forbid_action(:destroy) }
    end
  end
end
