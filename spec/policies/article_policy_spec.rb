require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy.new(user, article) }

  let(:resolved_scope) {
    ArticlePolicy::Scope.new(user, Article.all).resolve
  }

  context "being a visitor" do
    let(:user) { nil }
    
    context "accessing a published article" do
      let(:article) {
        FactoryGirl.create(:published_article_in_published_category) 
      }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing an unpublished article" do
      let(:article) {
        FactoryGirl.create(:unpublished_article_in_published_category) 
      }

      it "excludes article from resolved scope" do
        expect(resolved_scope).not_to include(article)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being a registered user" do
    let(:user) { FactoryGirl.create(:registered_user) }

    context "accessing a published article" do
      let(:article) {
        FactoryGirl.create(:published_article_in_published_category) 
      }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing an unpublished article" do
      let(:article) {
        FactoryGirl.create(:unpublished_article_in_published_category) 
      }

      it "excludes article from resolved scope" do
        expect(resolved_scope).not_to include(article)
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

    context "accessing a published article" do
      let(:article) {
        FactoryGirl.create(:published_article_in_published_category) 
      }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing an unpublished article the user contributes to" do
      let(:article) {
        FactoryGirl.create(
          :unpublished_article_in_published_category, 
          contributions: [
            Contribution.new(contributor_profile: contributor_profile)
          ]
        ) 
      }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end

    context "accessing an unpublished article the user doesn't contribute to" do
      let(:article) {
        FactoryGirl.create(:unpublished_article_in_published_category) 
      }

      it "excludes article from resolved scope" do
        expect(resolved_scope).not_to include(article)
      end

      it { should forbid_action(:show) }
      it { should forbid_new_and_create }
      it { should forbid_edit_and_update }
      it { should forbid_action(:destroy) }
    end
  end

  context "being an administrator" do
    let(:user) { FactoryGirl.create(:administrator) }

    context "accessing a published article" do
      let(:article) {
        FactoryGirl.create(:published_article_in_published_category) 
      }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }
      it { should permit_action(:destroy) }
    end

    context "accessing an unpublished article" do
      let(:article) {
        FactoryGirl.create(:unpublished_article_in_published_category) 
      }

      it "includes article in resolved scope" do
        expect(resolved_scope).to include(article)
      end

      it { should permit_action(:show) }
      it { should permit_new_and_create }
      it { should permit_edit_and_update }
      it { should permit_action(:destroy) }
    end
  end
end
