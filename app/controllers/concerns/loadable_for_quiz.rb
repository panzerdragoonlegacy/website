module LoadableForQuiz
  extend ActiveSupport::Concern
  include FindBySlugConcerns

  private

  def load_categories
    @categories =
      CategoryPolicy::Scope.new(
        current_user,
        Category.where(category_type: :quiz).order(:name)
      ).resolve
  end

  def load_quiz
    @quiz = Quiz.find_by slug: previewless_slug(params[:id])
    authorize @quiz
  end

  def load_contributors_quizzes
    @contributor_profile =
      find_contributor_profile_by_slug params[:contributor_profile_id]
    @quizzes =
      policy_scope(
        Quiz
          .joins(:contributions)
          .where(
            contributions: {
              contributor_profile_id: @contributor_profile.id
            }
          )
          .order(:name)
          .page(params[:page])
      )
  end

  def load_tagged_quizzes
    @tag = find_tag_by_slug params[:tag_id]
    @quizzes =
      policy_scope(
        Quiz
          .joins(:taggings)
          .where(taggings: { tag_id: @tag.id })
          .order(:name)
          .page(params[:page])
      )
  end

  def load_draft_quizzes
    @quizzes =
      policy_scope(Quiz.where(publish: false).order(:name).page(params[:page]))
  end
end
