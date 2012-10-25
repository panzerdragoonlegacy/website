class PoemsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @poems = Poem.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Poems"
    else
      @poems = Poem.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Poems"
    end
  end

  def show
    @commentable = @poem
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.order(:name)
  end

  def create 
    @poem = Poem.new(params[:poem])
    if @poem.save
      redirect_to @poem, :notice => "Successfully created poem."
    else
      render 'new'
    end
  end
  
  def update
    params[:poem][:dragoon_ids] ||= []
    if @poem.update_attributes(params[:poem])
      redirect_to @poem, :notice => "Successfully updated poem."
    else
      render 'edit'
    end
  end

  def destroy
    @poem.destroy
    redirect_to poems_path, :notice => "Successfully destroyed poem."
  end
end