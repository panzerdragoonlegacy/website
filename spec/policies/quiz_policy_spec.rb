require 'rails_helper'

describe QuizPolicy do
  subject { QuizPolicy.new(user, quiz) }

  let(:resolved_scope) {
    QuizPolicy::Scope.new(user, Quiz.all).resolve
  }

  context 'being a visitor' do
    let(:user) { nil }

    context 'accessing a published quiz' do
      let(:quiz) { FactoryGirl.create(:published_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished quiz' do
      let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

      it 'excludes quiz from resolved scope' do
        expect(resolved_scope).not_to include(quiz)
      end

      it { should forbid_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being a registered user' do
    let(:user) { FactoryGirl.create(:registered_user) }

    context 'accessing a published quiz' do
      let(:quiz) { FactoryGirl.create(:published_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { should permit_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished quiz' do
      let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

      it 'excludes quiz from resolved scope' do
        expect(resolved_scope).not_to include(quiz)
      end

      it { should forbid_action(:show) }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_mass_assignment_of(:publish) }
    end
  end

  context 'being a contributor' do
    let(:contributor_profile) {
      FactoryGirl.create(:contributor_profile)
    }
    let(:user) {
      FactoryGirl.create(
        :contributor,
        contributor_profile: contributor_profile
      )
    }

    context 'accessing quizzes that the user does not contribute to' do
      context 'accessing a published quiz' do
        let(:quiz) { FactoryGirl.create(:published_quiz) }

        it 'includes quiz in resolved scope' do
          expect(resolved_scope).to include(quiz)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished quiz' do
        let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

        it 'excludes quiz from resolved scope' do
          expect(resolved_scope).not_to include(quiz)
        end

        it { should forbid_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end

    context 'accessing quizzes the user contributes to' do
      context 'accessing a published quiz' do
        let(:quiz) {
          FactoryGirl.create(
            :published_quiz,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        }

        it 'includes quiz in resolved scope' do
          expect(resolved_scope).to include(quiz)
        end

        it { should permit_action(:show) }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end

      context 'accessing an unpublished quiz' do
        let(:quiz) {
          FactoryGirl.create(
            :unpublished_quiz,
            contributions: [
              Contribution.new(contributor_profile: contributor_profile)
            ]
          )
        }

        it 'includes quiz in resolved scope' do
          expect(resolved_scope).to include(quiz)
        end

        it { should permit_action(:show) }
        it { should permit_edit_and_update_actions }
        it { should permit_action(:destroy) }
        it { should forbid_mass_assignment_of(:publish) }
      end
    end
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing a published quiz' do
      let(:quiz) { FactoryGirl.create(:published_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished quiz' do
      let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
      it { should permit_mass_assignment_of(:publish) }
    end
  end
end
