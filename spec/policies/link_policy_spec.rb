require 'rails_helper'

describe LinkPolicy do
  subject { LinkPolicy.new(user, link) }

  let(:resolved_scope) {
    LinkPolicy::Scope.new(user, Link.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }

    context "accessing a link in a published category" do      
      let(:link) {
        FactoryGirl.create(:link_in_published_category)
      }

      it "includes link in resolved scope" do
        expect(resolved_scope).to include(link)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
    
    context "accessing a link in an unpublished category" do      
      let(:link) {
        FactoryGirl.create(:link_in_unpublished_category)
      }

      it "excludes link from resolved scope" do
        expect(resolved_scope).not_to include(link)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing a link in a published category" do
      let(:link) {
        FactoryGirl.create(:link_in_published_category)
      }

      it "includes link in resolved scope" do
        expect(resolved_scope).to include(link)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing a link in an unpublished category" do 
      let(:link) {
        FactoryGirl.create(:link_in_unpublished_category)
      }

      it "excludes link from resolved scope" do
        expect(resolved_scope).not_to include(link)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being a contributor" do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor, 
        contributor_profile: contributor_profile
      )
    }

    context "accessing links in a published category" do
      context "accessing links that the user does not contribute to" do
        let(:link) {
          FactoryGirl.create(:link_in_published_category)
        }

        it "includes link in resolved scope" do
          expect(resolved_scope).to include(link)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing links the user contributes to" do
        let(:link) {
          FactoryGirl.create(
            :link_in_published_category, 
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        }

        it "includes link in resolved scope" do
          expect(resolved_scope).to include(link)
        end

        it { should permit_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end

    context "accessing links in an unpublished category" do
      context "accessing links that the user does not contribute to" do
        let(:link) {
          FactoryGirl.create(:link_in_unpublished_category)
        }

        it "excludes link in resolved scope" do
          expect(resolved_scope).not_to include(link)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end

      context "accessing links that the user contributes to" do
        let(:link) {
          FactoryGirl.create(
            :link_in_unpublished_category, 
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        }

        it "excludes link in resolved scope" do
          expect(resolved_scope).not_to include(link)
        end

        it { should forbid_action(:show) }
        it { should forbid_new_and_create }
        it { should forbid_edit_and_update }
        it { should forbid_action(:destroy) }
      end
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing links in a published category" do
      let(:link) {
        FactoryGirl.create(:link_in_published_category)
      }

      it "includes link in resolved scope" do
        expect(resolved_scope).to include(link)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }
      it { should permit_action(:destroy) }
    end

    context "accessing links in an unpublished category" do
      let(:link) {
        FactoryGirl.create(:link_in_unpublished_category)
      }

      it "includes link in resolved scope" do
        expect(resolved_scope).to include(link)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }
      it { should permit_action(:destroy) }
    end
  end
end
