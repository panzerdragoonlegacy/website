class ProjectMembersController < ApplicationController
  load_resource
  authorize_resource
  
  def index
    @project = Project.find_by_url(params[:project_id])
    @dragoons = @project.dragoons.order(:name).page(params[:page])
    @title = @project.name + " Members"
  end
end
