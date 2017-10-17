class LinksController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_link, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_links
    else
      @links = policy_scope(Link.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @link.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @link = Link.new category: category
    else
      @link = Link.new
    end
    authorize @link
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @link = Link.new link_params
    authorize @link
    if @link.save
      flash[:notice] = 'Successfully created link.'
      redirect_to_link
    else
      render :new
    end
  end

  def update
    params[:link][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @link.update_attributes link_params
      flash[:notice] = 'Successfully updated link.'
      redirect_to_link
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to links_path, notice: 'Successfully destroyed link.'
  end

  private

  def link_params
    params.require(:link).permit(
      :category_id,
      :name,
      :url,
      :partner_site,
      :description,
      contributor_profile_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :link).order(:name)
    ).resolve
  end

  def load_link
    @link = Link.find params[:id]
    authorize @link
  end

  def load_contributors_links
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @links = policy_scope(
      Link.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def redirect_to_link
    if params[:continue_editing]
      redirect_to edit_link_path(@link)
    else
      redirect_to links_path
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:link][:contributor_profile_ids]
    )
      params[:link][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
