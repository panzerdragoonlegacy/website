class ProjectDiscussionsController < ApplicationController
  before_filter :projects
  before_filter :emoticons
  load_resource
  authorize_resource

  def show
    @project = @project_discussion.project
    @project_discussion_comments = @project_discussion.project_discussion_comments    
    @project_discussion_comment = ProjectDiscussionComment.new
  end

  def new
    @project = Project.find_by_url(params[:project_id])
  end

  def edit
    @project = Project.find_by_url(params[:project_id])
  end

  def create  
    @project_discussion = ProjectDiscussion.new(params[:project_discussion])
    @project_discussion.dragoon_id = current_dragoon.id
    if @project_discussion.save
      redirect_to @project_discussion.project
    else
      render 'new', :notice => "Successfully created discussion."
    end
  end

  def update
    if @project_discussion.update_attributes(params[:project_discussion])
      redirect_to [@project_discussion.project, @project_discussion]
    else
      render 'edit', :notice => "Successfully updated discussion."
    end
  end

  def destroy
    project = @project_discussion.project
    @project_discussion.destroy
    redirect_to project_path(project), :notice => "Successfully destroyed discussion."
  end

private

  def projects
    @projects = Project.accessible_by(current_ability).order(:name)
  end

  def emoticons
    @emoticons = Emoticon.order(:name)
  end
end