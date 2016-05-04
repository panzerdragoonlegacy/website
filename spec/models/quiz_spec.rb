require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:publish) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should have_many(:quiz_questions).dependent(:destroy) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'nested attributes' do
    it do
      should accept_nested_attributes_for(:quiz_questions).allow_destroy(true)
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it do
      should validate_length_of(:description).is_at_least(2).is_at_most(250)
    end

    describe 'validation of contributor profiles' do
      context 'quiz has less than one contributor profile' do
        let(:quiz) do
          FactoryGirl.build(
            :valid_quiz,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(quiz).not_to be_valid
        end
      end

      context 'quiz has at least one contributor profile' do
        let(:quiz) do
          FactoryGirl.build(
            :valid_quiz,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(quiz).to be_valid
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new quiz' do
      let(:quiz) do
        FactoryGirl.build :valid_quiz, name: 'Quiz 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        quiz.save
        expect(quiz.url).to eq 'quiz-1'
      end
    end

    context 'updating a quiz' do
      let(:quiz) do
        FactoryGirl.create :valid_quiz, name: 'Quiz 1'
      end

      it 'synchronises the slug with the updated name' do
        quiz.name = 'Quiz 2'
        quiz.save
        expect(quiz.url).to eq 'quiz-2'
      end
    end
  end
end
