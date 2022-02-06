module Sluggable
  extend ActiveSupport::Concern

  def slug_from_name
    generate_slug(name)
  end

  private

  def set_slug
    self.slug = self.slug_from_name if self.name.present?
  end

  def generate_slug(sluggable_string)
    sluggable_string.tr("'", '').tr('’', '').parameterize
  end
end
