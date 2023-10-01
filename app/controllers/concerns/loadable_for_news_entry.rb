module LoadableForNewsEntry
  extend ActiveSupport::Concern
  include FindBySlugConcerns
  include PreviewSlugConcerns

  private

  def load_news_entry
    slug = previewless_slug(params[:id])
    @news_entry = NewsEntry.find_by slug: slug
    @news_entry = NewsEntry.find_by alternative_slug: slug unless @news_entry
    authorize @news_entry
  end

  def load_contributors_news_entries
    @contributor_profile =
      find_contributor_profile_by_slug(params[:contributor_profile_id])
    @news_entries =
      policy_scope(
        NewsEntry
          .where(contributor_profile_id: @contributor_profile.id)
          .order('created_at desc')
          .page(params[:page])
      )
  end

  def load_tagged_news_entries
    @tag = find_tag_by_slug params[:tag_id]
    @news_entries =
      policy_scope(
        NewsEntry
          .joins(:taggings)
          .where(taggings: { tag_id: @tag.id })
          .order('created_at desc')
          .page(params[:page])
      )
  end

  def load_news_entries_for_year
    year = params[:year].to_i
    year_start_time = Time.utc(year, 1, 1)
    year_end_time = Time.utc(year, 12, 31, 11, 59, 59)
    @news_entries =
      policy_scope(
        NewsEntry
          .where(published_at: (year_start_time..year_end_time))
          .order('published_at desc')
          .page(params[:page])
      )
  end

  def load_news_entries_for_atom_feed
    @news_entries =
      policy_scope(NewsEntry.order('published_at desc').page(params[:page]))
  end

  def load_draft_news_entries
    @news_entries =
      policy_scope(
        NewsEntry
          .where(publish: false)
          .order('created_at desc')
          .page(params[:page])
      )
  end

  private

  def newest_news_entry_year
    news_entry = NewsEntry.where(publish: true).order(:published_at).last
    news_entry ? news_entry.published_at.year : nil
  end

  def oldest_news_entry_year
    news_entry = NewsEntry.where(publish: true).order(:published_at).first
    news_entry ? news_entry.published_at.year : nil
  end

  def load_news_entry_years
    @news_entry_years = []
    first_year = newest_news_entry_year
    last_year = oldest_news_entry_year
    if first_year && last_year
      year = first_year
      while year >= last_year
        @news_entry_years << year
        year = year - 1
      end
    end
  end
end
