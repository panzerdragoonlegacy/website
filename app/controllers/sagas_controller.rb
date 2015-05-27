class SagasController < ApplicationController
  before_action :load_encyclopaedia_entries, except: [:index, :destroy]
  before_action :load_saga, except: [:index, :new, :create]

  def index
    @sagas = policy_scope(Saga.order(:sequence_number).page(params[:page]))
  end

  def new
    @saga = Saga.new
    authorize @saga
  end

  def create
    @saga = Saga.new(saga_params)
    authorize @saga
    if @saga.save
      flash[:notice] = "Successfully created saga."
      if params[:continue_editing]
        redirect_to edit_saga_path(@saga)
      else
        redirect_to sagas_path
      end
    else
      render :new
    end
  end

  def update
    if @saga.update_attributes(saga_params)
      flash[:notice] = "Successfully updated saga."
      if params[:continue_editing]
        redirect_to edit_saga_path(@saga)
      else
        redirect_to sagas_path
      end
    else
      render :edit
    end
  end

  def destroy
    @saga.destroy
    redirect_to sagas_path, notice: "Successfully destroyed saga."
  end

  private

  def saga_params
    params.require(:saga).permit(
      :encyclopaedia_entry_id,
      :sequence_number,
      :name
    )
  end

  def load_encyclopaedia_entries
    @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.order(:name))
  end

  def load_saga
    @saga = Saga.find_by url: params[:id]
    authorize @saga
  end
end
