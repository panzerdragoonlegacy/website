class NewsEntriesController < ApplicationController
  before_action :load_news_entry, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      unless @contributor_profile = ContributorProfile.find_by(
        url: params[:contributor_profile_id])
        raise "Contributor profile not found."
      end
      @news_entries = policy_scope(NewsEntry.where(
        contributor_profile_id: @contributor_profile.id).order(
        "created_at desc").page(params[:page]))
    elsif params[:filter] == 'draft'
      @news_entries = policy_scope(NewsEntry.where(publish: false).
        order("created_at desc").page(params[:page]))
    else
      @news_entries = policy_scope(NewsEntry.order("created_at desc").page(
        params[:page]))
    end
  end

  def new
    @news_entry = NewsEntry.new
    authorize @news_entry
  end

  def create
    @news_entry = NewsEntry.new(news_entry_params)
    authorize @news_entry
    if @news_entry.save
      flash[:notice] = "Successfully created news entry."
      if params[:continue_editing]
        redirect_to edit_news_entry_path(@news_entry)
      else
        redirect_to @news_entry
      end
    else
      render :new
    end
  end

  def update
    if @news_entry.update_attributes(news_entry_params)
      flash[:notice] = "Successfully updated news entry."
      if params[:continue_editing]
        redirect_to edit_news_entry_path(@news_entry)
      else
        redirect_to @news_entry
      end
    else
      render :edit
    end
  end

  def destroy
    @news_entry.destroy
    redirect_to news_entries_path, notice: "Successfully destroyed news entry."
  end

  private

  def news_entry_params
    params.require(:news_entry).permit(
      policy(@news_entry || :news_entry).permitted_attributes
    )
  end

  def load_news_entry
    @news_entry = NewsEntry.find_by url: params[:id]
    authorize @news_entry
  end
end
