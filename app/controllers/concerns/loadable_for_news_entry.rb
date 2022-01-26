module LoadableForNewsEntry
  extend ActiveSupport::Concern
  include FindBySlugConcerns
  include PreviewSlugConcerns

  private

  def load_news_entry
    @news_entry = NewsEntry.find_by slug: previewless_slug(params[:id])
    authorize @news_entry
  end

  def load_contributors_news_entries
    @contributor_profile = find_contributor_profile_by_slug(
      params[:contributor_profile_id]
    )
    @news_entries = policy_scope(
      NewsEntry.where(contributor_profile_id: @contributor_profile.id)
        .order('created_at desc').page(params[:page])
    )
  end

  def load_tagged_news_entries
    @tag = find_tag_by_slug params[:tag_id]
    @news_entries = policy_scope(
      NewsEntry.joins(:taggings).where(taggings: { tag_id: @tag.id })
        .order('created_at desc').page(params[:page])
    )
  end

  def load_draft_news_entries
    @news_entries = policy_scope(
      NewsEntry.where(publish: false).order('created_at desc')
        .page(params[:page])
    )
  end
end
