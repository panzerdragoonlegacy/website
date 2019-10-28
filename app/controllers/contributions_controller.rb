class ContributionsController < ApplicationController
  def index
    @pictures = policy_scope(
      Picture.where(publish: true).order(published_at: :desc).page(params[:page])
    )
  end
end
