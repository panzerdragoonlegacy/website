class QuizzesController < ApplicationController
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @quizzes = policy_scope(Quiz.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @quizzes = policy_scope(Quiz.order(:name).page(params[:page]))
    end
  end

  def show
    @quiz = Quiz.find_by_url(params[:id])
    authorize @quiz
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
    @quiz = Quiz.new(params[:quiz])
    authorize @quiz
    if @quiz.save
      redirect_to @quiz, notice: "Successfully created quiz."
    else  
      render :new
    end
  end

  def edit
    @quiz = Quiz.find_by_url(params[:id])
    authorize @quiz
    quiz_question = @quiz.quiz_questions.build  
    3.times { quiz_question.quiz_answers.build }  
  end
  
  def update
    @quiz = Quiz.find_by_url(params[:id])
    authorize @quiz
    params[:quiz][:dragoon_ids] ||= []  
    if @quiz.update_attributes(params[:quiz])
      redirect_to @quiz, notice: "Successfully updated quiz."
    else
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find_by_url(params[:id])
    authorize @quiz
    @quiz.destroy
    redirect_to quizzes_path, notice: "Successfully destroyed quiz."
  end

end
