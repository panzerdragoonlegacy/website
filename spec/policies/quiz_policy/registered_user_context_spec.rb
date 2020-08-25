require 'rails_helper'

describe QuizPolicy do
  subject { described_class.new(user, quiz) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Quiz.all).resolve
  end

  let(:user) { FactoryBot.create(:registered_user) }

  context 'registered user accessing a published quiz' do
    let(:quiz) { FactoryBot.create(:published_quiz) }

    it 'includes quiz in resolved scope' do
      expect(resolved_scope).to include(quiz)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end

  context 'registered user accessing an unpublished quiz' do
    let(:quiz) { FactoryBot.create(:unpublished_quiz) }

    it 'excludes quiz from resolved scope' do
      expect(resolved_scope).not_to include(quiz)
    end

    it { is_expected.to forbid_actions([:show, :edit, :update, :destroy]) }
    it { is_expected.to forbid_mass_assignment_of(:publish) }
  end
end
