class EmoticonsController < ApplicationController
  authorize_resource
  
  def index
    @emoticons = Emoticon.order(:name).page(params[:page]) 
  end

  def new
    @emoticon = Emoticon.new
  end

  def create
    @emoticon = Emoticon.new(params[:emoticon])
    if @emoticon.save
      redirect_to emoticons_path, :notice => "Successfully created emoticon."
    else
      render 'new'
    end
  end

  def destroy    
    @emoticon = Emoticon.find(params[:id])
    @emoticon.destroy
    redirect_to emoticons_path, :notice => "Successfully destroyed emoticon."
  end
end