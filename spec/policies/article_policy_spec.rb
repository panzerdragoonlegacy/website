require 'rails_helper'

describe ArticlePolicy do
  subject { ArticlePolicy }

  permissions :show? do
    context "for a visitor" do
      let(:user) { nil }

      it "grants access if article is published and it's category is published" do
        expect(subject).to permit(user, FactoryGirl.create(:published_article_in_published_category))
      end

      it "denies access if article is not published and it's category is published" do
        expect(subject).not_to permit(user, FactoryGirl.create(:unpublished_article_in_published_category))
      end
    end

    context "for a registered user who is not a contributor to the article" do
      let(:user) { FactoryGirl.create(:registered_user) }

      it "grants access if the article is published and it's category is published" do
        expect(subject).to permit(user, FactoryGirl.create(:published_article_in_published_category))
      end

      pending it "denies access if the article is not published and it's category is published" do
        expect(subject).not_to permit(user, FactoryGirl.create(:unpublished_article_in_published_category))
      end
    end

    context "for a registered user who is a contributor to the article" do
      # Todo
    end

    context "for an administrator" do
      let(:user) { FactoryGirl.create(:administrator) }

      it "grants access if article is published and it's category is published" do
        expect(subject).to permit(user, FactoryGirl.create(:published_article_in_published_category))
      end

      it "grants access if article is not published and it's category is published" do
        expect(subject).to permit(user, FactoryGirl.create(:unpublished_article_in_published_category))
      end
    end
  end
end
