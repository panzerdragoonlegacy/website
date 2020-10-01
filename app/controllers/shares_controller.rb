class SharesController < ApplicationController
  include LoadableForShare

  def index
    if params[:contributor_profile_id]
      load_contributors_shares
    else
      load_category_groups
      @shares = policy_scope(Share.order(:published_at).page(params[:page]))
    end
  end
end
