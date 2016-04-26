require 'rails_helper'

RSpec.describe Relation, type: :model do
  describe 'fields' do
    it { should respond_to(:encyclopaedia_entry) }
    it { should respond_to(:relatable) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:encyclopaedia_entry) }
    it { should belong_to(:relatable) }
  end
end
