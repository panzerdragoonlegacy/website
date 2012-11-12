class EncyclopaediaEntriesController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource

  def index
    @encyclopaedia_entries = EncyclopaediaEntry.accessible_by(current_ability).order(:name).page(params[:page]) 
  end

  def show
  end

  def create 
    @encyclopaedia_entry = EncyclopaediaEntry.new(params[:encyclopaedia_entry])
    if @encyclopaedia_entry.save
      redirect_to @encyclopaedia_entry, :notice => "Successfully created encyclopaedia entry."
    else
      render 'new'
    end
  end

  def update
    if @encyclopaedia_entry.update_attributes(params[:encyclopaedia_entry])
      redirect_to @encyclopaedia_entry, :notice => "Successfully updated encyclopaedia entry."
    else
      render 'edit'
    end
  end

  def destroy    
    @encyclopaedia_entry.destroy
    redirect_to encyclopaedia_entries_path, :notice => "Successfully destroyed encyclopaedia entry."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :encyclopaedia_entry).order(:name)
  end  
end