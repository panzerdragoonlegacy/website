class Admin::EncyclopaediaEntriesController < ApplicationController
  include LoadableForEncyclopaediaEntry
  layout 'admin'
  before_action :load_categories, except: [:destroy]
  before_action :load_encyclopaedia_entry, except: [:index, :new, :create]

  def index
    clean_publish_false_param
    @q = EncyclopaediaEntry.order(:name).ransack(params[:q])
    @encyclopaedia_entries = policy_scope(
      @q.result.includes(:category).page(params[:page])
    )
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @encyclopaedia_entry = EncyclopaediaEntry.new category: category
    else
      @encyclopaedia_entry = EncyclopaediaEntry.new
    end
    authorize @encyclopaedia_entry
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @encyclopaedia_entry = EncyclopaediaEntry.new encyclopaedia_entry_params
    authorize @encyclopaedia_entry
    if @encyclopaedia_entry.save
      flash[:notice] = 'Successfully created encyclopaedia entry.'
      redirect_to_encyclopaedia_entry
    else
      render :new
    end
  end

  def update
    params[:encyclopaedia_entry][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @encyclopaedia_entry.update_attributes encyclopaedia_entry_params
      flash[:notice] = 'Successfully updated encyclopaedia entry.'
      redirect_to_encyclopaedia_entry
    else
      render :edit
    end
  end

  def destroy
    @encyclopaedia_entry.destroy
    redirect_to(
      admin_encyclopaedia_entries_path,
      notice: 'Successfully destroyed encyclopaedia entry.'
    )
  end

  private

  def encyclopaedia_entry_params
    params.require(:encyclopaedia_entry).permit(
      policy(@encyclopaedia_entry || :encyclopaedia_entry).permitted_attributes
    )
  end

  def redirect_to_encyclopaedia_entry
    if params[:continue_editing]
      redirect_to edit_admin_encyclopaedia_entry_path(@encyclopaedia_entry)
    else
      redirect_to @encyclopaedia_entry
    end
  end
  
  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:encyclopaedia_entry][:contributor_profile_ids]
    )
      params[:encyclopaedia_entry][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
