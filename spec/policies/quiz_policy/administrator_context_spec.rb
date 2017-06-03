require 'rails_helper'

describe QuizPolicy do
  subject { described_class.new(user, quiz) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Quiz.all).resolve
  end

  let(:user) { FactoryGirl.create(:administrator) }

  context 'administrator accessing a published quiz' do
    let(:quiz) { FactoryGirl.create(:published_quiz) }

    it 'includes quiz in resolved scope' do
      expect(resolved_scope).to include(quiz)
    end

    it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end

  context 'administrator accessing an unpublished quiz' do
    let(:quiz) { FactoryGirl.create(:unpublished_quiz) }

    it 'includes quiz in resolved scope' do
      expect(resolved_scope).to include(quiz)
    end

    it { is_expected.to permit_actions([:show, :edit, :update, :destroy]) }
    it { is_expected.to permit_mass_assignment_of(:publish) }
  end
end
