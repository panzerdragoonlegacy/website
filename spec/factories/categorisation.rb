FactoryBot.define do
  factory :categorisation do
    factory :valid_categorisation do
      sequence(:sequence_number) { |n| n + 1 }
      short_name_in_parent { 'Test Short Name' }
      parent { FactoryBot.create(:valid_category) }
      subcategory_id do
        subcategory = FactoryBot.create(:valid_category)
        subcategory.id
      end
    end
  end
end
