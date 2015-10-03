require 'rails_helper'

describe CategoryGroupPolicy do
  subject { CategoryGroupPolicy.new(user, category_group) }

  let(:resolved_scope) {
    CategoryGroupPolicy::Scope.new(user, CategoryGroup.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }
    
    context "accessing a category group" do
      let(:category_group) {
        FactoryGirl.create(:category_group) 
      }

      it "includes category group in resolved scope" do
        expect(resolved_scope).to include(category_group)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing a category group" do
      let(:category_group) {
        FactoryGirl.create(:category_group) 
      }

      it "includes category group in resolved scope" do
        expect(resolved_scope).to include(category_group)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing a category group" do
      let(:category_group) {
        FactoryGirl.create(:category_group) 
      }

      it "includes category group in resolved scope" do
        expect(resolved_scope).to include(category_group)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }

      context "category has no children" do
        it { should permit_action(:destroy) }
      end

      context "category has children" do
        before do
          category_group.categories << FactoryGirl.create(:category)
        end

        it { should forbid_action(:destroy) }
      end
    end
  end
end
