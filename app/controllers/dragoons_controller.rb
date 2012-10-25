class DragoonsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    @dragoons = Dragoon.order(:name).page(params[:page]) 
  end
  
  def show
    @news_entry_count = NewsEntry.accessible_by(current_ability).where(:dragoon_id => @dragoon.id).count  
    @article_count = Article.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @download_count = Download.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @link_count = Link.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @music_track_count = MusicTrack.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @picture_count = Picture.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @poem_count = Poem.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @quiz_count = Quiz.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @resource_count = Resource.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @story_count = Story.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @video_count = Video.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).count
    @discussion_count = Discussion.accessible_by(current_ability).where(:dragoon_id => @dragoon.id).count
    @comment_count = Comment.accessible_by(current_ability).where(:dragoon_id => @dragoon.id).count
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