class QuizzesController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @quizzes = Quiz.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Quizzes"
    else
      @quizzes = Quiz.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Quizzes"
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
    quiz_question = @quiz.quiz_questions.build  
    3.times { quiz_question.quiz_answers.build }  
  end

  def edit
    quiz_question = @quiz.quiz_questions.build  
    3.times { quiz_question.quiz_answers.build }  
  end
  
  def create  
    @quiz = Quiz.new(params[:quiz])
    if @quiz.save
      redirect_to @quiz, :notice => "Successfully created quiz."
    else  
      render 'new'
    end
  end
  
  def update
    params[:quiz][:dragoon_ids] ||= []  
    if @quiz.update_attributes(params[:quiz])
      redirect_to @quiz, :notice => "Successfully updated quiz."
    else
      render 'edit'
    end
  end

  def destroy    
    @quiz.destroy
    redirect_to quizzes_path, :notice => "Successfully destroyed quiz."
  end
end