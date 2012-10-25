class CommentsController < ApplicationController
  before_filter :emoticons
  load_resource
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @comments = Comment.accessible_by(current_ability).where(:dragoon_id => @dragoon.id).order("created_at desc").page(params[:page])
      @title = @dragoon.name + "'s Comments"
    else
      @comments = Comment.accessible_by(current_ability).order("created_at desc").page(params[:page])
      @title = "Comments"
    end
  end

  def create
    @commentable = params[:commentable_type].classify.constantize.find_by_url(params[:commentable_url])
    @comment = @commentable.comments.build(params[:comment])
    @comment.dragoon_id = current_dragoon.id
    if @comment.save
      
      # Create view records, marking the comment as unviewed for all dragoons.
      dragoons = Dragoon.all
      dragoons.each do |dragoon|
        view = View.new
        view.dragoon_id = dragoon.id
        view.viewable_id = @comment.id
        view.viewable_type = 'Comment'
        view.viewed = false
        view.save
      end
      
      redirect_to session[:redirect_path], :notice => "Successfully created comment."
    else  
      render "new"
    end
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      redirect_to session[:redirect_path], :notice => "Successfully updated comment."
    else
      render "edit"
    end
  end

  def destroy
    @comment.destroy
    redirect_to session[:redirect_path], :notice => "Successfully destroyed comment."
  end
 
private

  # Not needed anymore???
  def find_commentable    
    return @comment.commentable_type.classify.constantize.find(@comment.commentable_id)
  end

  def emoticons
    @emoticons = Emoticon.order(:name)
  end  
end