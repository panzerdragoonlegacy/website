require 'rails_helper'

RSpec.describe QuizAnswer, type: :model do
  describe 'fields' do
    it { should respond_to(:content) }
    it { should respond_to(:correct_answer) }
    it { should respond_to(:quiz_question) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:quiz_question) }
  end
end
