require 'rails_helper'

RSpec.describe QuizQuestion, type: :model do
  describe 'fields' do
    it { should respond_to(:content) }
    it { should respond_to(:quiz) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should have_many(:quiz_answers).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it do
      should accept_nested_attributes_for(:quiz_answers).allow_destroy(true)
    end
  end
end
