class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  #after_filter :verify_authorized, except: :index
  #after_filter :verify_policy_scoped, only: :index

  helper_method :current_dragoon
  before_filter :sagas
  before_filter :partner_sites

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def current_dragoon
    if session[:dragoon_id]
      @current_dragoon = Dragoon.find(session[:dragoon_id])
    else
      @current_dragoon ||= dragoon_from_remember_token
    end
  end

  def dragoon_from_remember_token
    Dragoon.authenticate_with_remember_token(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def sagas
    @sagas = policy_scope(Saga.order(:sequence_number))
  end

  def partner_sites
    @partner_sites = policy_scope(Link.where(partner_site: true).order(:name))
  end
end
