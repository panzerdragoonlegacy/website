require 'rails_helper'

RSpec.describe Categorisation, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:sequence_number) }
    it { is_expected.to respond_to(:subcategory) }
    it { is_expected.to respond_to(:short_name_in_parent) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it do
      is_expected.to belong_to(:parent)
        .class_name('Category')
        .with_foreign_key('parent_id')
        .inverse_of(:categorisations)
    end
    it do
      is_expected.to belong_to(:subcategory)
        .class_name('Category')
        .with_foreign_key('subcategory_id')
        .inverse_of(:categorisation)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:subcategory_id) }
    it { is_expected.to validate_presence_of(:short_name_in_parent) }
    it do
      is_expected.to validate_length_of(:short_name_in_parent)
        .is_at_least(1)
        .is_at_most(50)
    end
    it do
      is_expected.to validate_numericality_of(:sequence_number)
        .is_greater_than_or_equal_to(1)
        .is_less_than_or_equal_to(99)
    end
  end
end
