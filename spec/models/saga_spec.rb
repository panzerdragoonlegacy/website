require 'rails_helper'

RSpec.describe Saga, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:slug) }
    it { is_expected.to respond_to(:sequence_number) }
    it { is_expected.to respond_to(:tag) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to have_many(:categories).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(30)
    end
    it { is_expected.to validate_presence_of(:sequence_number) }
    it do
      is_expected.to validate_numericality_of(:sequence_number)
        .is_greater_than(0).is_less_than(100)
    end
  end

  describe 'slug' do
    context 'creating a new saga' do
      let(:saga) do
        FactoryBot.build :valid_saga, name: 'Saga 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        saga.save
        expect(saga.slug).to eq 'saga-1'
      end
    end

    context 'updating a saga' do
      let(:saga) do
        FactoryBot.create :valid_saga, name: 'Saga 1'
      end

      it 'synchronises the slug with the updated name' do
        saga.name = 'Saga 2'
        saga.save
        expect(saga.slug).to eq 'saga-2'
      end
    end
  end
end
