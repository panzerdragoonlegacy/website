class DiscussionsController < ApplicationController
  before_filter :forums
  before_filter :emoticons
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @discussions = Discussion.accessible_by(current_ability).where(:dragoon_id => @dragoon.id).order("created_at desc").page(params[:page])
      @title = @dragoon.name + "'s Discussions"
    else
      @discussions = Discussion.accessible_by(current_ability).order("created_at desc").page(params[:page])
      @title = "Discussions"
    end
  end
 
  def show
    
    # Get discussion's comments.
    @comments = Comment.where(:commentable_id => @discussion.id, :commentable_type => 'Discussion')
    
    if @current_dragoon
      # Get view record to see if the discussion has been viewed.
      view = View.where(:dragoon_id => @current_dragoon.id, :viewable_id => @discussion.id, :viewable_type => 'Discussion').first

      # Set @unread variable to display new discussion marker.
      if view  
        if (view.viewed == true)
          @discussion_unviewed = false
        else
          @discussion_unviewed = true
          
          # Sets view record as viewed in the database.
          view.viewed = true
          view.save
        end
      end

      # Mark comments as viewed in the database.  
      @comments_unviewed = Hash.new
      @comments.each do |comment|
        # Get view record to see if the comment has been viewed.
        view = View.where(:dragoon_id => @current_dragoon.id, :viewable_id => comment.id, :viewable_type => 'Comment').first
        if view
          if view.viewed == true
            @comments_unviewed[comment.id] = false
          else
            @comments_unviewed[comment.id] = true
            
            # Sets view record as viewed in the database.
            view.viewed = true
            view.save
          end
        end
      end
    end
    
    #@commentable = @discussion
    #@comments = Comment.where(:commentable_id => @discussion.id, :commentable_type => 'Discussion')
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
  end

  def new
    if params[:category]
      @discussion.category_id = Category.find_by_url(params[:category]).id
    end
  end

  def edit
  end
  
  def create  
    @discussion = Discussion.new(params[:discussion])
    @discussion.dragoon_id = current_dragoon.id
    if @discussion.save
      
      # Create view records, marking the discussion as unviewed for all dragoons.
      dragoons = Dragoon.all
      dragoons.each do |dragoon|
        view = View.new
        view.dragoon_id = dragoon.id
        view.viewable_id = @discussion.id
        view.viewable_type = 'Discussion'
        view.viewed = false
        view.save
      end
      
      redirect_to @discussion
    else
      render 'new', :notice => "Successfully created discussion."
    end
  end

  def update
    if @discussion.update_attributes(params[:discussion])
      redirect_to @discussion
    else
      render 'edit', :notice => "Successfully updated discussion."
    end
  end

  def destroy
    forum = @discussion.forum
    @discussion.destroy
    redirect_to forum_path(forum), :notice => "Successfully destroyed discussion."
  end
  
private

  def forums
    @forums = Forum.accessible_by(current_ability).order(:number)
  end
  
  def emoticons
    @emoticons = Emoticon.order(:name)
  end
end