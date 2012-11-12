class DragoonsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    @dragoons = Dragoon.order(:name).page(params[:page]) 
  end
  
  def show
    @news_entry_count = @dragoon.news_entries.accessible_by(current_ability).count  
    @article_count = @dragoon.articles.accessible_by(current_ability).count
    @download_count = @dragoon.downloads.accessible_by(current_ability).count
    @link_count = @dragoon.links.accessible_by(current_ability).count
    @music_track_count = @dragoon.music_tracks.accessible_by(current_ability).count
    @picture_count = @dragoon.pictures.accessible_by(current_ability).count
    @poem_count = @dragoon.poems.accessible_by(current_ability).count
    @quiz_count = @dragoon.quizzes.accessible_by(current_ability).count
    @resource_count = @dragoon.resources.accessible_by(current_ability).count
    @story_count = @dragoon.stories.accessible_by(current_ability).count
    @video_count = @dragoon.videos.accessible_by(current_ability).count
    @discussion_count = @dragoon.discussions.accessible_by(current_ability).count
    @comment_count = @dragoon.comments.accessible_by(current_ability).count
    @website_contributions_count = @news_entry_count.to_i + @article_count.to_i + @download_count.to_i + @link_count.to_i + 
      @music_track_count.to_i + @picture_count.to_i + @poem_count.to_i + @quiz_count.to_i + @resource_count.to_i + 
      @story_count.to_i + @video_count.to_i
    @community_contributions_count = @discussion_count.to_i + @comment_count.to_i
  end

  def create
    @dragoon = Dragoon.new(params[:dragoon])
    if @dragoon.save
      session[:dragoon_id] = @dragoon.id
      if params[:stay_logged_in]
        @dragoon.create_remember_token
        cookies.permanent.signed[:remember_token] = [@dragoon.id, @dragoon.remember_token]
      end
      redirect_to root_url, :notice => "Signed up!"  
    else  
      render 'new' 
    end  
  end

  def update
    if @dragoon.update_attributes(params[:dragoon])
      redirect_to @dragoon, :notice => "Successfully updated profile."
    else
      render 'edit'
    end
  end

  def destroy    
    @dragoon.destroy
    redirect_to dragoons_path, :notice => "Successfully destroyed dragoon."
  end
  
end