class SharesController < ApplicationController
  def index
    @shares = policy_scope(
      Share.where(show_in_feed: true)
        .order(created_at: :desc)
        .page(params[:page])
    )
  end
end
