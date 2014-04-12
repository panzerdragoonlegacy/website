class NewsEntriesController < ApplicationController

  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @news_entries = policy_scope(NewsEntry.where(dragoon_id: @dragoon.id).order("created_at desc").page(params[:page]))
    else
      @news_entries = policy_scope(NewsEntry.order("created_at desc").page(params[:page]))
    end
  end

  def show
    @news_entry = NewsEntry.find_by_url(params[:id])
    authorize @news_entry
  end

  def new
    @news_entry = NewsEntry.new
    authorize @news_entry
  end

  def create 
    @news_entry = NewsEntry.new(news_entry_params)
    authorize @news_entry
    @news_entry.dragoon = current_dragoon
    if @news_entry.save
      redirect_to @news_entry, notice: "Successfully created news entry."
    else
      render :new
    end
  end

  def edit
    @news_entry = NewsEntry.find_by_url(params[:id])
    authorize @news_entry
  end
  
  def update
    @news_entry = NewsEntry.find_by_url(params[:id])
    authorize @news_entry
    if @news_entry.update_attributes(params[:news_entry])
      redirect_to @news_entry, notice: "Successfully updated news entry."
    else
      render :edit
    end
  end

  def destroy
    @news_entry = NewsEntry.find_by_url(params[:id])
    authorize @news_entry
    @news_entry.destroy
    redirect_to news_entries_path, notice: "Successfully destroyed news entry."
  end

  private

  def news_entry_params
    params.require(:news_entry).permit(
      :name,
      :content,
      :publish
    )
  end
  
end
