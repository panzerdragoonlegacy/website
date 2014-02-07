class ApplicationController < ActionController::Base  
  protect_from_forgery
  helper_method :current_dragoon
  helper_method :current_ability
  helper_method :projects
  before_filter :set_dragoon_time_zone
  before_filter :partner_sites
      
  private
  
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
  
  # Overrides default method used by CanCan.
  def current_ability
    @current_ability ||= Ability.new(current_dragoon)
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
