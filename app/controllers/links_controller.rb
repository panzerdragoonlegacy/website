class LinksController < ApplicationController
  before_filter :categories
  load_resource
  authorize_resource
    
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @links = Link.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Links"
    else
      @links = Link.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Links"
    end
  end
  
  def create
    @link = Link.new(params[:link])
    if @link.save
      redirect_to links_path, :notice => "Successfully created link."
    else  
      render 'new'
    end
  end
  
  def update
    if @link.update_attributes(params[:link])
      redirect_to links_path, :notice => "Successfully updated link."
    else
      render 'edit'
    end
  end

  def destroy
    @link.destroy
    redirect_to links_path, :notice => "Successfully destroyed link."
  end
  
private
  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :link).order(:name)
  end
end