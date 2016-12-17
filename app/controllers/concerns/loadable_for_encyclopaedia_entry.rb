module LoadableForEncyclopaediaEntry
  extend ActiveSupport::Concern

  included do
    def load_category_groups
      @category_groups = policy_scope(
        CategoryGroup.where(
          category_group_type: :encyclopaedia_entry
        ).order(:name)
      )
    end

    def load_categories
      @categories = CategoryPolicy::Scope.new(
        current_user,
        Category.where(category_type: :encyclopaedia_entry).order(:name)
      ).resolve
    end

    def load_encyclopaedia_entry
      @encyclopaedia_entry = EncyclopaediaEntry.find_by url: params[:id]
      authorize @encyclopaedia_entry
    end

    def load_draft_encyclopaedia_entries
      @encyclopaedia_entries = policy_scope(
        EncyclopaediaEntry.where(publish: false)
          .order(:name).page(params[:page])
      )
    end

    def load_articles
      @articles = ArticlePolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.articles.order(:name)
      ).resolve
    end

    def load_downloads
      @downloads = DownloadPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.downloads.order(:name)
      ).resolve
    end

    def load_links
      @links = LinkPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.links.order(:name)
      ).resolve
    end

    def load_music_tracks
      @music_tracks = MusicTrackPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.music_tracks.order(:name)
      ).resolve
    end

    def load_pictures
      @pictures = PicturePolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.pictures.order(:name)
      ).resolve
    end

    def load_poems
      @poems = PoemPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.poems.order(:name)
      ).resolve
    end

    def load_quizzes
      @quizzes = QuizPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.quizzes.order(:name)
      ).resolve
    end

    def load_resources
      @resources = ResourcePolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.resources.order(:name)
      ).resolve
    end

    def load_stories
      @stories = StoryPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.stories.order(:name)
      ).resolve
    end

    def load_videos
      @videos = VideoPolicy::Scope.new(
        current_user,
        @encyclopaedia_entry.videos.order(:name)
      ).resolve
    end
  end
end
