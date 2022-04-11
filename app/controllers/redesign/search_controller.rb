class Redesign::SearchController < ApplicationController
  def index
    sanitized_query = Sanitize.fragment params[:query]
    redirect_to(
      'https://duckduckgo.com/?q=site:panzerdragoonlegacy.com+' +
        sanitized_query,
      allow_other_host: true
    )
  end
end
