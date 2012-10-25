class ProjectsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource

  def show
    @project_discussions = @project.project_discussions.order("created_at desc").page(params[:page])
  end
  
  def create  
    @project = Project.new(params[:project])
    if @project.save
      redirect_to @project, :notice => "Successfully created project."
    else  
      render 'new'
    end
  end
  
  def update
    params[:project][:dragoon_ids] ||= []
    if @project.update_attributes(params[:project])
      redirect_to @project, :notice => "Successfully updated project."
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, :notice => "Successfully destroyed project."
  end
end
