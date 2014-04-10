class PoemsController < ApplicationController

  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @poems = policy_scope(Poem.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @poems = policy_scope(Poem.order(:name).page(params[:page]))
    end
  end

  def show
    @poem = Poem.find_by_url(params[:id])
    authorize @poem
  end

  def new
    @poem = Poem.new
    authorize @poem
  end
  
  def create 
    @poem = Poem.new(params[:poem])
    authorize @poem
    if @poem.save
      redirect_to @poem, notice: "Successfully created poem."
    else
      render :new
    end
  end

  def edit
    @poem = Poem.find_by_url(params[:id])
    authorize @poem
  end
  
  def update
    @poem = Poem.find_by_url(params[:id])
    authorize @poem
    params[:poem][:dragoon_ids] ||= []
    if @poem.update_attributes(params[:poem])
      redirect_to @poem, notice: "Successfully updated poem."
    else
      render :edit
    end
  end

  def destroy
    @poem = Poem.find_by_url(params[:id])
    authorize @poem
    @poem.destroy
    redirect_to poems_path, notice: "Successfully destroyed poem."
  end
  
end
