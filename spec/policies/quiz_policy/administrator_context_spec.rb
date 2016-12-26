require 'rails_helper'

describe QuizPolicy do
  subject { described_class.new(user, quiz) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Quiz.all).resolve
  end

  context 'being an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }

    context 'accessing a published quiz' do
      let(:quiz) { FactoryGirl.create(:published_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end

    context 'accessing an unpublished quiz' do
      let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

      it 'includes quiz in resolved scope' do
        expect(resolved_scope).to include(quiz)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_mass_assignment_of(:publish) }
    end
  end
end
