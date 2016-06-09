require 'rails_helper'

RSpec.describe Relation, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:encyclopaedia_entry) }
    it { is_expected.to respond_to(:relatable) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:encyclopaedia_entry) }
    it { is_expected.to belong_to(:relatable) }
  end
end
