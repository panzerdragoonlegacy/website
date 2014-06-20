class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_filter :verify_authorized, except: :index
  after_filter :verify_policy_scoped, only: :index

  helper_method :current_user
  helper_method :current_dragoon
  helper_method :current_ability
  helper_method :projects
  before_filter :set_dragoon_time_zone
  before_filter :partner_sites
      
  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def current_user
    current_dragoon
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
    
  def set_dragoon_time_zone
    Time.zone = current_dragoon.time_zone if current_dragoon
  end
  
  def partner_sites
    @partner_sites = Link.where(partner_site: true).order(:name)
  end
  
  def projects
    if @current_dragoon
      @projects = Project.order(:name).joins(:project_members).where(:project_members => {:dragoon_id => @current_dragoon.id})
    end
  end
end
