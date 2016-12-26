require 'rails_helper'

describe ArticlePolicy do
  subject { described_class.new(user, article) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Article.all).resolve
  end

  context 'being a contributor' do
    let(:contributor_profile) do
      FactoryGirl.create(:valid_contributor_profile)
    end
    let(:user) do
      FactoryGirl.create(
        :contributor,
        contributor_profile: contributor_profile
      )
    end

    context 'creating a new article' do
      let(:article) { Article.new }

      it { is_expected.to permit_new_and_create_actions }
      it { is_expected.to forbid_mass_assignment_of(:publish) }
    end

    context 'accessing articles in a published category' do
      context 'accessing articles that the user does not contribute to' do
        context 'accessing a published article' do
          let(:article) do
            FactoryGirl.create(:published_article_in_published_category)
          end

          it 'includes article in resolved scope' do
            expect(resolved_scope).to include(article)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished article' do
          let(:article) do
            FactoryGirl.create(:unpublished_article_in_published_category)
          end

          it 'excludes article from resolved scope' do
            expect(resolved_scope).not_to include(article)
          end

          it { is_expected.to forbid_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing articles the user contributes to' do
        context 'accessing a published article' do
          let(:article) do
            FactoryGirl.create(
              :published_article_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes article in resolved scope' do
            expect(resolved_scope).to include(article)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished article' do
          let(:article) do
            FactoryGirl.create(
              :unpublished_article_in_published_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes article in resolved scope' do
            expect(resolved_scope).to include(article)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to permit_edit_and_update_actions }
          it { is_expected.to permit_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end

    context 'accessing articles in an unpublished category' do
      context 'accessing articles that the user does not contribute to' do
        context 'accessing a published article' do
          let(:article) do
            FactoryGirl.create(:published_article_in_published_category)
          end

          it 'includes article in resolved scope' do
            expect(resolved_scope).to include(article)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished article' do
          let(:article) do
            FactoryGirl.create(:unpublished_article_in_published_category)
          end

          it 'excludes article from resolved scope' do
            expect(resolved_scope).not_to include(article)
          end

          it { is_expected.to forbid_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end

      context 'accessing articles that the user contributes to' do
        context 'accessing a published article' do
          let(:article) do
            FactoryGirl.create(
              :published_article_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes article in resolved scope' do
            expect(resolved_scope).to include(article)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to forbid_edit_and_update_actions }
          it { is_expected.to forbid_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end

        context 'accessing an unpublished article' do
          let(:article) do
            FactoryGirl.create(
              :unpublished_article_in_unpublished_category,
              contributions: [
                Contribution.new(contributor_profile: contributor_profile)
              ]
            )
          end

          it 'includes article in resolved scope' do
            expect(resolved_scope).to include(article)
          end

          it { is_expected.to permit_action(:show) }
          it { is_expected.to permit_edit_and_update_actions }
          it { is_expected.to permit_action(:destroy) }
          it { is_expected.to forbid_mass_assignment_of(:publish) }
        end
      end
    end
  end
end
