class TagsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    @tags = Tag.order(:name).page(params[:page]) 
  end

  def show
    @articles = Article.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Article"})
    @discussions = Discussion.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Discussion"})
    @downloads = Download.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Download"})
    @links = Link.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Link"})
    @music_tracks = MusicTrack.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "MusicTrack"})
    @pictures = Picture.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Picture"})
    @poems = Poem.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Poem"})
    @quizzes = Quiz.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Quiz"})
    @resources = Resource.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Resource"})
    @stories = Story.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Story"})
    @videos = Video.accessible_by(current_ability).joins(:taggings).where(:taggings => {:tag_id => @tag.id, :taggable_type => "Video"}) 
  end
  
  def create  
    @tag = Tag.new(params[:tag])
    if @tag.save
      redirect_to tags_path, :notice => "Successfully created tag."
    else  
      render 'new'
    end
  end
  
  def update
    if @tag.update_attributes(params[:tag])
      redirect_to tags_path, :notice => "Successfully updated tag."
    else
      render 'edit'
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, :notice => "Successfully destroyed tag."
  end
end