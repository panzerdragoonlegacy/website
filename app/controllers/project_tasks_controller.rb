class ProjectTasksController < ApplicationController
  before_filter :projects
  before_filter :dragoons
  load_resource
  authorize_resource
  
  def index
    @project = Project.find_by_url(params[:project])
    @project_tasks = @project.project_tasks.order("completed, name").page(params[:page])
    @title = @project.name + " Tasks"
  end

  def create 
    @project_task = ProjectTask.new(params[:project_task])
    if @project_task.save
      redirect_to project_tasks_path(:project => @project_task.project), :notice => "Successfully created project task."
    else
      render 'new'
    end
  end
  
  def update
    if @project_task.update_attributes(params[:project_task])
      redirect_to project_tasks_path(:project => @project_task.project), :notice => "Successfully updated project task."
    else
      render 'edit'
    end
  end

  def destroy
    @project = @project_task.project   
    @project_task.destroy
    redirect_to project_tasks_path(:project => @project), :notice => "Successfully destroyed project task."
  end
  
private

  def projects
    @projects = Project.accessible_by(current_ability).order(:name)
  end
  
  def dragoons
    @dragoons = Dragoon.order(:name)
  end
end