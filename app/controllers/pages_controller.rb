class PagesController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    @pages = Page.accessible_by(current_ability).order(:name).page(params[:page]) 
  end
  
  def show
    @emoticons = Emoticon.order(:name)
  end

  def create 
    @page = Page.new(params[:page])
    if @page.save
      redirect_to @page, :notice => "Successfully created page."
    else
      render 'new'
    end
  end
  
  def update
    if @page.update_attributes(params[:page])
      redirect_to @page, :notice => "Successfully updated page."
    else
      render 'edit'
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_path, :notice => "Successfully destroyed page."
  end
end