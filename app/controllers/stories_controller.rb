class StoriesController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_story, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_stories
    elsif params[:filter] == 'draft'
      load_draft_stories
    else
      @stories = policy_scope(Story.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @story.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @story = Story.new category: category
    else
      @story = Story.new
    end
    authorize @story
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @story = Story.new story_params
    authorize @story
    if @story.save
      flash[:notice] = 'Successfully created story.'
      redirect_to_story
    else
      render :new
    end
  end

  def update
    params[:story][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @story.update_attributes story_params
      flash[:notice] = 'Successfully updated story.'
      redirect_to_story
    else
      render :edit
    end
  end

  def destroy
    @story.destroy
    redirect_to stories_path, notice: 'Successfully destroyed story.'
  end

  private

  def story_params
    params.require(:story).permit(
      policy(@story || :story).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :story).order(:name)
    ).resolve
  end

  def load_story
    @story = Story.find_by url: params[:id]
    authorize @story
  end

  def load_contributors_stories
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @stories = policy_scope(
      Story.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_stories
    @stories = policy_scope(
      Story.where(publish: false).order(:name).page(params[:page])
    )
  end

  def redirect_to_story
    if params[:continue_editing]
      redirect_to edit_story_path(@story)
    else
      redirect_to @story
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:story][:contributor_profile_ids]
    )
      params[:story][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
