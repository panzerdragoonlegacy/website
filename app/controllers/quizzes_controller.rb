class QuizzesController < ApplicationController
  before_action :load_quiz, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_quizzes
    elsif params[:filter] == 'draft'
      load_draft_quizzes
    else
      @quizzes = policy_scope(Quiz.order(:name).page(params[:page]))
    end
  end

  def show
    if params[:commit]
      check_quiz_results if params[:results]
    else
      flash.now[:notice] = "You haven't filled out the quiz."
    end
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @quiz.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    @quiz = Quiz.new
    authorize @quiz
    quiz_question = @quiz.quiz_questions.build
    3.times { quiz_question.quiz_answers.build }
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @quiz = Quiz.new quiz_params
    authorize @quiz
    if @quiz.save
      flash[:notice] = 'Successfully created quiz.'
      redirect_to_quiz
    else
      render :new
    end
  end

  def edit
    quiz_question = @quiz.quiz_questions.build
    3.times { quiz_question.quiz_answers.build }
  end

  def update
    params[:quiz][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @quiz.update_attributes quiz_params
      flash[:notice] = 'Successfully updated quiz.'
      redirect_to_quiz
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_path, notice: 'Successfully destroyed quiz.'
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      policy(@quiz || :quiz).permitted_attributes
    )
  end

  def load_quiz
    @quiz = Quiz.find_by url: params[:id]
    authorize @quiz
  end

  def load_contributors_quizzes
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @quizzes = policy_scope(
      Quiz.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_quizzes
    @quizzes = policy_scope(
      Quiz.where(publish: false).order(:name).page(params[:page])
    )
  end

  def redirect_to_quiz
    if params[:continue_editing]
      redirect_to edit_quiz_path(@quiz)
    else
      redirect_to @quiz
    end
  end

  def check_quiz_results
    if params[:results].count < @quiz.quiz_questions.count
      flash.now[:notice] = 'You must fill out all questions.'
    else
      @show_results = true
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:quiz][:contributor_profile_ids]
    )
      params[:quiz][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
