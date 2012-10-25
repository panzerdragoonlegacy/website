class NewsEntriesController < ApplicationController
  before_filter :emoticons
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @news_entries = NewsEntry.accessible_by(current_ability).where(:dragoon_id => @dragoon.id).order("created_at desc").page(params[:page])
      @title = @dragoon.name + "'s News Entries"
    else
      @news_entries = NewsEntry.accessible_by(current_ability).order("created_at desc").page(params[:page])
      @title = "Panzer Dragoon and Crimson Dragon News"
    end
  end

  def show
    @dragoon = @news_entry.dragoon
    @commentable = @news_entry
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
  end

  def create 
    @news_entry = NewsEntry.new(params[:news_entry])
    @news_entry.dragoon = current_dragoon
    if @news_entry.save
      redirect_to @news_entry, :notice => "Successfully created news entry."
    else
      render 'new'
    end
  end
  
  def update
    if @news_entry.update_attributes(params[:news_entry])
      redirect_to @news_entry, :notice => "Successfully updated news entry."
    else
      render 'edit'
    end
  end

  def destroy    
    @news_entry.destroy
    redirect_to news_entries_path, :notice => "Successfully destroyed news entry."
  end
  
private

  def emoticons
    @emoticons = Emoticon.order(:name)
  end
end