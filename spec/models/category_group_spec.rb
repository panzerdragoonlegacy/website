require 'rails_helper'

RSpec.describe CategoryGroup, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:category_group_type) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should have_many(:categories).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
  end

  describe 'slug' do
    context 'creating a new category group' do
      let(:category_group) do
        FactoryGirl.build :valid_category_group, name: 'Category Group 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        category_group.save
        expect(category_group.url).to eq 'category-group-1'
      end
    end

    context 'updating a category group' do
      let(:category_group) do
        FactoryGirl.create :valid_category_group, name: 'Category Group 1'
      end

      it 'synchronises the slug with the updated name' do
        category_group.name = 'Category Group 2'
        category_group.save
        expect(category_group.url).to eq 'category-group-2'
      end
    end
  end
end
