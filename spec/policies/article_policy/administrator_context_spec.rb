require 'rails_helper'

describe ArticlePolicy do
  subject { described_class.new(user, article) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Article.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'administrator creating a new article' do
    let(:article) { Article.new }

    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing articles in a published category' do
    context 'accessing a published article' do
      let(:article) do
        FactoryGirl.create(:published_article_in_published_category)
      end

      it 'includes article in resolved scope' do
        expect(resolved_scope).to include(article)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished article' do
      let(:article) do
        FactoryGirl.create(:unpublished_article_in_published_category)
      end

      it 'includes article in resolved scope' do
        expect(resolved_scope).to include(article)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end

  context 'administrator accessing articles in an unpublished category' do
    context 'accessing a published article' do
      let(:article) do
        FactoryGirl.create(:published_article_in_unpublished_category)
      end

      it 'includes article in resolved scope' do
        expect(resolved_scope).to include(article)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished article' do
      let(:article) do
        FactoryGirl.create(:unpublished_article_in_unpublished_category)
      end

      it 'includes article in resolved scope' do
        expect(resolved_scope).to include(article)
      end

      it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
