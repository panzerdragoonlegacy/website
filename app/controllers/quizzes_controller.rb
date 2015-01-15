class QuizzesController < ApplicationController
  before_action :load_quiz, except: [:index, :new, :create]

  def index
    if params[:dragoon_id]
      unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
        raise "Dragoon not found."
      end
      @quizzes = policy_scope(Quiz.joins(:contributions).where(
        contributions: { dragoon_id: @dragoon.id }).order(:name).page(
        params[:page]))
    else
      @quizzes = policy_scope(Quiz.order(:name).page(params[:page]))
    end
  end

  def show
    if params[:commit]
      if params[:results]
        if params[:results].count < @quiz.quiz_questions.count
          flash.now[:notice] = "You must fill out all questions."
        else
          @show_results = true
        end
      else
        flash.now[:notice] = "You haven't filled out the quiz."
      end
    end
  end

  def new
    @quiz = Quiz.new
    authorize @quiz
    quiz_question = @quiz.quiz_questions.build
    3.times { quiz_question.quiz_answers.build }
  end

  def create
    @quiz = Quiz.new(quiz_params)
    authorize @quiz
    if @quiz.save
      flash[:notice] = "Successfully created quiz."
      if params[:continue_editing]
        redirect_to edit_quiz_path(@quiz)
      else
        redirect_to @quiz
      end
    else
      render :new
    end
  end

  def edit
    quiz_question = @quiz.quiz_questions.build
    3.times { quiz_question.quiz_answers.build }
  end

  def update
    params[:quiz][:dragoon_ids] ||= []
    if @quiz.update_attributes(quiz_params)
      flash[:notice] = "Successfully updated quiz."
      if params[:continue_editing]
        redirect_to edit_quiz_path(@quiz)
      else
        redirect_to @quiz
      end
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_path, notice: "Successfully destroyed quiz."
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      :name,
      :description,
      :publish,
      quiz_questions_attributes: [
        :content, quiz_answers_attributes: [
          :content, :correct_answer
        ]
      ],
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_quiz
    @quiz = Quiz.find_by url: params[:id]
    authorize @quiz
  end
end
