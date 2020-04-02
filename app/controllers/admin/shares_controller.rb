class Admin::SharesController < ApplicationController
  include LoadableForShare
  layout 'admin'
  before_action :load_categories, except: [:destroy]
  before_action :load_share, except: [:index, :new, :create]

  def index
    @q = Share.order(created_at: :desc).ransack(params[:q])
    @shares = policy_scope(@q.result.page(params[:page]))
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @share = Share.new category: category
    else
      @share = Share.new
    end
    authorize @share
  end

  def create
    @share = Share.new share_params
    make_current_user_the_contributor
    authorize @share
    if @share.save
      flash[:notice] = 'Successfully created share.'
      redirect_to_share
    else
      render :new
    end
  end

  def update
    if @share.update_attributes share_params
      flash[:notice] = 'Successfully updated share.'
      redirect_to_share
    else
      render :edit
    end
  end

  def destroy
    @share.destroy
    redirect_to(
      admin_shares_path,
      notice: 'Successfully destroyed share.'
    )
  end

  private

  def share_params
    params.require(:share).permit(
      policy(@share || :share).permitted_attributes
    )
  end

  def redirect_to_share
    if params[:continue_editing]
      redirect_to edit_admin_share_path(@share)
    else
      redirect_to admin_shares_path
    end
  end

  def make_current_user_the_contributor
    @share.contributor_profile_id = current_user.contributor_profile_id
  end
end
