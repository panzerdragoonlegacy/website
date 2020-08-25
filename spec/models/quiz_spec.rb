require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:quiz_questions).dependent(:destroy) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it do
      is_expected.to have_many(:contributor_profiles).through(:contributions)
    end
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  describe 'nested attributes' do
    it do
      is_expected.to accept_nested_attributes_for(:quiz_questions)
        .allow_destroy(true)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end

    describe 'validation of contributor profiles' do
      context 'quiz has less than one contributor profile' do
        let(:quiz) do
          FactoryBot.build(
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
          FactoryBot.build(
            :valid_quiz,
            contributor_profiles: [
              FactoryBot.create(:valid_contributor_profile)
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
        FactoryBot.build :valid_quiz, name: 'Quiz 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        quiz.save
        expect(quiz.url).to eq 'quiz-1'
      end
    end

    context 'updating a quiz' do
      let(:quiz) do
        FactoryBot.create :valid_quiz, name: 'Quiz 1'
      end

      it 'synchronises the slug with the updated name' do
        quiz.name = 'Quiz 2'
        quiz.save
        expect(quiz.url).to eq 'quiz-2'
      end
    end
  end
end
