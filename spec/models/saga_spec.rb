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

  describe 'associations' do
    it { should belong_to(:encyclopaedia_entry) }
  end
end
