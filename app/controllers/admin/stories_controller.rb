class Admin::StoriesController < ApplicationController
  include LoadableForStory
  include Sortable
  layout 'admin'
  before_action :load_categories, except: [:destroy]
  before_action :load_story, except: [:index, :new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @stories = policy_scope(
      Story.order(sort_column + ' ' + sort_direction).page(params[:page])
    )
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
    redirect_to admin_stories_path, notice: 'Successfully destroyed story.'
  end

  private

  def story_params
    params.require(:story).permit(
      policy(@story || :story).permitted_attributes
    )
  end

  def redirect_to_story
    if params[:continue_editing]
      redirect_to edit_admin_story_path(@story)
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

  def sort_column
    Story.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
end
