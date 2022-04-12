module CategoriesHelper
  def category_has_subcategories(category)
    category.categorisations.count > 0
  end

  def category_has_subcategories_of_media_type(category, media_type)
    category.categorisations.each do |categorisation|
      return true if categorisation.subcategory.category_type == media_type
    end
    false
  end

  def category_has_subcategories_of_multiple_types(category)
    previous_category_type = nil
    category.categorisations.each do |categorisation|
      category_type = categorisation.subcategory.category_type
      if previous_category_type && previous_category_type != category_type
        return true
      end
      previous_category_type = category_type
    end
    false
  end
end
