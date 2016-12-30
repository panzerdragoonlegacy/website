require 'rails_helper'

describe CategoryPolicy do
  subject { described_class.new(user, category) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Category.all).resolve
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing a published category' do
      let(:category) do
        FactoryGirl.create(:published_category)
      end

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }


      context 'category has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'category has children' do
        before do
          category.articles << FactoryGirl.create(
            :published_article_in_published_category
          )
        end

        it { is_expected.to forbid_action(:destroy) }
      end
    end

    context 'accessing an unpublished category' do
      let(:category) do
        FactoryGirl.create(:unpublished_category)
      end

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_mass_assignment_of(:publish) }

      context 'category has no children' do
        it { is_expected.to permit_action(:destroy) }
      end

      context 'category has children' do
        before do
          category.articles << FactoryGirl.create(
            :published_article_in_published_category
          )
        end

        it { is_expected.to forbid_action(:destroy) }
      end
    end
  end
end