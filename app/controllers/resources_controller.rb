class ResourcesController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource

  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @resources = Resource.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Resources"
    else
      @resources = Resource.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Resources"
    end
  end

  def show
    @commentable = @resource
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.order(:name)
  end

  def create 
    @resource = Resource.new(params[:resource])
    if @resource.save
      redirect_to @resource, :notice => "Successfully created resource."
    else
      render 'new'
    end
  end
  
  def update
    params[:resource][:dragoon_ids] ||= []  
    if @resource.update_attributes(params[:resource])
      redirect_to @resource, :notice => "Successfully updated resource."
    else
      render 'edit'
    end
  end

  def destroy    
    @resource.destroy
    redirect_to resources_path, :notice => "Successfully destroyed resource."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :resource).order(:name)
  end  
end