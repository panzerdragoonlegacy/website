class PoemsController < ApplicationController
  before_action :load_poem, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_poems
    elsif params[:filter] == 'draft'
      load_draft_poems
    else
      @poems = policy_scope(Poem.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @poem.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    @poem = Poem.new
    authorize @poem
  end

  def create
    @poem = Poem.new(poem_params)
    authorize @poem
    if @poem.save
      flash[:notice] = 'Successfully created poem.'
      redirect_to_poem
    else
      render :new
    end
  end

  def update
    params[:poem][:contributor_profile_ids] ||= []
    if @poem.update_attributes(poem_params)
      flash[:notice] = 'Successfully updated poem.'
      redirect_to_poem
    else
      render :edit
    end
  end

  def destroy
    @poem.destroy
    redirect_to poems_path, notice: 'Successfully destroyed poem.'
  end

  private

  def poem_params
    params.require(:poem).permit(
      policy(@poem || :poem).permitted_attributes
    )
  end

  def load_poem
    @poem = Poem.find_by url: params[:id]
    authorize @poem
  end

  def load_contributors_poems
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @poems = policy_scope(
      Poem.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_poems
    @poems = policy_scope(
      Poem.where(publish: false).order(:name).page(params[:page])
    )
  end

  def redirect_to_poem
    if params[:continue_editing]
      redirect_to edit_poem_path(@poem)
    else
      redirect_to @poem
    end
  end
end
