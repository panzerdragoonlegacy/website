require 'rails_helper'

RSpec.describe QuizQuestion, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:quiz) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:quiz) }
    it { is_expected.to have_many(:quiz_answers).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it do
      is_expected.to accept_nested_attributes_for(:quiz_answers)
        .allow_destroy(true)
    end
  end
end
