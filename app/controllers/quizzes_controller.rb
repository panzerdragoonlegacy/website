class QuizzesController < ApplicationController
  include LoadableForQuiz

  def index
    if params[:contributor_profile_id]
      load_contributors_quizzes
    else
      @quizzes = policy_scope(Quiz.order(:name).page(params[:page]))
    end
  end

  def show
    load_quiz
    if params[:commit]
      check_quiz_results if params[:results]
    else
      flash.now[:notice] = "You haven't filled out the quiz."
    end
    @tags = TagPolicy::Scope.new(
      current_user,
      Tag.where(name: @quiz.tags.map { |tag| tag.name }).order(:name)
    ).resolve
  end

  private

  def check_quiz_results
    if params[:results].count < @quiz.quiz_questions.count
      flash.now[:notice] = 'You must fill out all questions.'
    else
      @show_results = true
    end
  end
end
