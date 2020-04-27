class SharesController < ApplicationController
  def index
    @shares = policy_scope(
      Share.where(show_in_feed: true, publish: true)
        .order(published_at: :desc)
        .page(params[:page])
    )
  end
end
