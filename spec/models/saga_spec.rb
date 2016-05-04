require 'rails_helper'

RSpec.describe Saga, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:sequence_number) }
    it { should respond_to(:encyclopaedia_entry) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:encyclopaedia_entry) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(30) }
    it { should validate_presence_of(:sequence_number) }
    it do
      should validate_numericality_of(:sequence_number).is_greater_than(0)
        .is_less_than(100)
    end
    it { should validate_presence_of(:encyclopaedia_entry) }
    xit { should validate_uniqueness_of(:encyclopaedia_entry) }
  end

  describe 'slug' do
    context 'creating a new saga' do
      let(:saga) do
        FactoryGirl.build :valid_saga, name: 'Saga 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        saga.save
        expect(saga.url).to eq 'saga-1'
      end
    end

    context 'updating a saga' do
      let(:saga) do
        FactoryGirl.create :valid_saga, name: 'Saga 1'
      end

      it 'synchronises the slug with the updated name' do
        saga.name = 'Saga 2'
        saga.save
        expect(saga.url).to eq 'saga-2'
      end
    end
  end
end
