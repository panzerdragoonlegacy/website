class ProjectDiscussionCommentsController < ApplicationController
  before_filter :emoticons
  load_resource
  authorize_resource
  
  def edit
    @project_discussion = ProjectDiscussion.find(params[:project_discussion_id])
    @project = @project_discussion.project
  end
  
  def create
    @project_discussion = ProjectDiscussion.find(params[:project_discussion_id])
    @project_discussion_comment = @project_discussion.project_discussion_comments.build(params[:project_discussion_comment])
    @project_discussion_comment.dragoon_id = current_dragoon.id
    if @project_discussion_comment.save
      redirect_to project_project_discussion_path(@project_discussion.project, @project_discussion), :notice => "Successfully created comment."
    else
      render "new"
    end
  end

  def update
    @project_discussion = ProjectDiscussion.find(params[:project_discussion_id])
    if @project_discussion_comment.update_attributes(params[:project_discussion_comment])
      redirect_to project_project_discussion_path(@project_discussion.project, @project_discussion), :notice => "Successfully updated comment."
    else
      render "edit"
    end
  end

  def destroy
    project_discussion = @project_discussion_comment.project_discussion
    @project_discussion_comment.destroy
    redirect_to project_project_discussion_path(project_discussion.project, project_discussion), :notice => "Successfully destroyed comment."
  end

private

  def emoticons
    @emoticons = Emoticon.order(:name)
  end
end