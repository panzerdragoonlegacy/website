module FindBySlugConcerns
  extend ActiveSupport::Concern

  private

  def find_category_by_slug(slug)
    category = Category.find_by slug: slug
    raise 'Category not found.' unless category.present?
    category
  end

  def find_contributor_profile_by_slug(slug)
    contributor_profile = ContributorProfile.find_by slug: slug
    raise 'Contributor profile not found.' unless contributor_profile.present?
    contributor_profile
  end

  def find_tag_by_slug(slug)
    tag = Tag.find_by slug: slug
    raise 'Tag not found.' unless tag.present?
    tag
  end
end
