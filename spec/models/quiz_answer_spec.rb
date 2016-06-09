require 'rails_helper'

RSpec.describe QuizAnswer, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:correct_answer) }
    it { is_expected.to respond_to(:quiz_question) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:quiz_question) }
  end
end
