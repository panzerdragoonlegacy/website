require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:slug) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:category_type) }
    is { is_expected.to respond_to(:list_view) }
    it { is_expected.to respond_to(:category_picture) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it do
      is_expected.to have_many(:categorisations)
        .with_foreign_key(:parent_id)
        .dependent(:destroy)
        .inverse_of(:parent)
    end
    it do
      is_expected.to belong_to(:categorisation).with_foreign_key(:id).optional
    end
    it do
      is_expected.to have_many(:subcategories)
        .through(:categorisations)
        .with_foreign_key(:subcategory_id)
    end
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to have_many(:pictures).dependent(:destroy) }
    it { is_expected.to have_many(:music_tracks).dependent(:destroy) }
    it { is_expected.to have_many(:videos).dependent(:destroy) }
    it { is_expected.to have_many(:downloads).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description)
        .is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category_type) }
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:category_picture) }
    it do
      is_expected.to validate_attachment_content_type(:category_picture)
        .allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:category_picture).less_than(
        5.megabytes
      )
    end
  end

  describe 'slug' do
    context 'creating a new category' do
      let(:category) { FactoryBot.build :valid_category, name: 'Category 1' }

      it 'generates a slug that is a parameterised version of the name' do
        category.save
        expect(category.slug).to eq 'category-1'
      end
    end

    context 'updating a category' do
      let(:category) { FactoryBot.create :valid_category, name: 'Category 1' }

      it 'synchronises the slug with the updated name' do
        category.name = 'Category 2'
        category.save
        expect(category.slug).to eq 'category-2'
      end
    end
  end
end
