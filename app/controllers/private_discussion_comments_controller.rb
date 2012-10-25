class PrivateDiscussionCommentsController < ApplicationController
  before_filter :emoticons
  load_and_authorize_resource :private_discussion
  load_and_authorize_resource :private_discussion_comment, :through => :private_discussion

  def edit
    @private_discussion = PrivateDiscussion.find(params[:private_discussion_id])
  end

  def create
    @private_discussion = PrivateDiscussion.find(params[:private_discussion_id])
    @private_discussion_comment = @private_discussion.private_discussion_comments.build(params[:private_discussion_comment])
    @private_discussion_comment.dragoon_id = current_dragoon.id
    if @private_discussion_comment.save
      redirect_to private_discussion_path(@private_discussion), :notice => "Successfully created comment."
    else
      render "new"
    end
  end

  def update
    @private_discussion = PrivateDiscussion.find(params[:private_discussion_id])
    if @private_discussion_comment.update_attributes(params[:private_discussion_comment])
      redirect_to private_discussion_path(@private_discussion), :notice => "Successfully updated comment."
    else
      render "edit"
    end
  end

  def destroy
    private_discussion = @private_discussion_comment.private_discussion
    @private_discussion_comment.destroy
    redirect_to private_discussion_path(private_discussion), :notice => "Successfully destroyed comment."
  end

private

  def emoticons
    @emoticons = Emoticon.order(:name)
  end
end