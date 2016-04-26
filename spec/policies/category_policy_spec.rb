require 'rails_helper'

describe CategoryPolicy do
  subject { CategoryPolicy.new(user, category) }

  let(:resolved_scope) {
    CategoryPolicy::Scope.new(user, Category.all).resolve
  }

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing a published category' do
      let(:category) {
        FactoryGirl.create(:published_category)
      }

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end

    context 'accessing an unpublished category' do
      let(:category) {
        FactoryGirl.create(:unpublished_category)
      }

      it 'excludes category from resolved scope' do
        expect(resolved_scope).not_to include(category)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'accessing a published category' do
      let(:category) {
        FactoryGirl.create(:published_category)
      }

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end

    context 'accessing an unpublished category' do
      let(:category) {
        FactoryGirl.create(:unpublished_category)
      }

      it 'excludes category from resolved scope' do
        expect(resolved_scope).not_to include(category)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing a published category' do
      let(:category) {
        FactoryGirl.create(:published_category)
      }

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }

      context 'category has no children' do
        it { should permit_action(:destroy) }
      end

      context 'category has children' do
        before do
          category.articles << FactoryGirl.create(
            :published_article_in_published_category
          )
        end

        it { should forbid_action(:destroy) }
      end
    end

    context 'accessing an unpublished category' do
      let(:category) {
        FactoryGirl.create(:unpublished_category)
      }

      it 'includes category in resolved scope' do
        expect(resolved_scope).to include(category)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create_actions }
      it { should permit_edit_and_update_actions }

      context 'category has no children' do
        it { should permit_action(:destroy) }
      end

      context 'category has children' do
        before do
          category.articles << FactoryGirl.create(
            :published_article_in_published_category
          )
        end

        it { should forbid_action(:destroy) }
      end
    end
  end
end
