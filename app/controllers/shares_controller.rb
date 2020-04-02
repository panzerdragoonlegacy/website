class SharesController < ApplicationController
  def index
    @shares = policy_scope(Share.order(created_at: :desc).page(params[:page]))
  end
end
