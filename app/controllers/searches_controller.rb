class SearchesController < ApplicationController
  skip_after_action :verify_authorized

  def create
    sanitized_query = Sanitize.fragment params[:query]
    redirect_to(
      'https://duckduckgo.com/?q=site:panzerdragoonlegacy.com+' +
      sanitized_query
    )
  end
end
