class PoemsController < ApplicationController

  before_action :load_poem, except: [:index, :new, :create]

  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
      @poems = policy_scope(Poem.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @poems = policy_scope(Poem.order(:name).page(params[:page]))
    end
  end

  def new
    @poem = Poem.new
    authorize @poem
  end
  
  def create 
    @poem = Poem.new(poem_params)
    authorize @poem
    if @poem.save
      redirect_to @poem, notice: "Successfully created poem."
    else
      render :new
    end
  end

  def update
    params[:poem][:dragoon_ids] ||= []
    if @poem.update_attributes(poem_params)
      redirect_to @poem, notice: "Successfully updated poem."
    else
      render :edit
    end
  end

  def destroy
    @poem.destroy
    redirect_to poems_path, notice: "Successfully destroyed poem."
  end
  
  private

  def poem_params
    params.require(:poem).permit(
      :name,
      :description,
      :content,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_poem
    @poem = Poem.find_by url: params[:id]
    authorize @poem
  end

end
