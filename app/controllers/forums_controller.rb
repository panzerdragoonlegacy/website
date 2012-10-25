class ForumsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource

  def index
    @forums = Forum.accessible_by(current_ability).order(:number)
  end

  def show
   # @discussions = Discussion.all.sort_by(&:latest_comment_time)
    #@discussions = Discussion.all.sort_by(&:latest_comment_time)
    
    #@discussions = Discussion.where(:forum_id => @forum.id).sort_by(&:latest_comment_time) #.order(:desc)
    
   # @discussions = Discussion.where(:forum_id => @forum.id).joins(:comments).where(:comments => {:commentable_id => @discussion.id})
    @discussions = Discussion.where(:forum_id => @forum.id)
      
   # .where(:forum_id => @forum.id).order('latest_comment_time desc')
    
       #.accessible_by(current_ability).where(:category_id => @category.id).order(:subject).page(params[:page])
   
  end

  def create  
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to @forum, :notice => "Successfully created forum."
    else  
      render 'new'
    end
  end

  def update
    if @forum.update_attributes(params[:forum])
      redirect_to @forum, :notice => "Successfully updated forum."
    else
      render 'edit'
    end
  end

  def destroy
    @forum.destroy
    redirect_to forums_path, :notice => "Successfully destroyed forum."
  end
end
