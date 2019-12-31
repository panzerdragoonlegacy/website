class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # after_filter :verify_authorized, except: :index
  # after_filter :verify_policy_scoped, only: :index

  before_action :sagas_for_left_nav
  before_action :partner_sites
  before_action :site_footer_pages

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end

  def sagas_for_left_nav
    @sagas_for_left_nav = policy_scope Saga.order(:sequence_number)
  end

  def partner_sites
    @partner_sites = Link.where(partner_site: true).order(:name)
  end

  def site_footer_pages
    @site_footer_pages =
      policy_scope(Page.where(page_type: :site_footer.to_s)).order(:name)
  end

  # This allows all records to be displayed in a Ransack search when 'Drafts
  # Only' is unchecked.
  def clean_publish_false_param
    if params[:q]
      params[:q].delete_if { |k,v| k == 'publish_false' && v == '0' }
    end
  end
end
