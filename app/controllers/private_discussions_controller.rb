class PrivateDiscussionsController < ApplicationController
  before_filter :emoticons
  load_and_authorize_resource :private_discussion

  def index
    @private_discussions = PrivateDiscussion.joins(:private_discussion_members).where(:private_discussion_members => {:dragoon_id => @current_dragoon.id}).order("created_at desc").page(params[:page])
  end

  def show
    @private_discussion_comments = @private_discussion.private_discussion_comments
    @private_discussion_comment = PrivateDiscussionComment.new
  end

  def create
    # Create empty dragoons_ids param if it does not exist.
    params[:private_discussion][:dragoon_ids] ||= []
    
    # Make the creator of the private discussion a private discussion member.      
    params[:private_discussion][:dragoon_ids].push(@current_dragoon.id)
    
    @private_discussion = PrivateDiscussion.new(params[:private_discussion])
    @private_discussion.dragoon_id = current_dragoon.id
    if @private_discussion.save
      redirect_to @private_discussion
    else
      render 'new', :notice => "Successfully created private discussion."
    end
  end

  def update
    params[:private_discussion][:dragoon_ids] ||= []
    if @private_discussion.update_attributes(params[:private_discussion])
      redirect_to @private_discussion
    else
      render 'edit', :notice => "Successfully updated private discussion."
    end
  end

  def destroy
    @private_discussion.destroy
    redirect_to private_discussions_path, :notice => "Successfully destroyed private discussion."
  end

private

  def emoticons
    @emoticons = Emoticon.order(:name)
  end
end
