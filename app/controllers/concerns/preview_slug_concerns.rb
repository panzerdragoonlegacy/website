module PreviewSlugConcerns
  extend ActiveSupport::Concern

  private

  def previewless_slug(slug)
    slug.chomp '&preview'
  end

  def custom_path(previewable, base_path)
    previewable.publish ? base_path : "#{base_path}&preview"
  end
end
