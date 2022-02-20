class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Pundit::NotDefinedError, with: :attempt_to_redirect

  # after_filter :verify_authorized, except: :index
  # after_filter :verify_policy_scoped, only: :index

  before_action :set_paper_trail_whodunnit
  before_action :sagas_for_left_nav
  before_action :main_menu_categories
  after_action :conditionally_set_session_cookie

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end

  def attempt_to_redirect
    redirect = Redirect.find_by old_url: request.fullpath
    if redirect
      redirect_to URI.parse(redirect.new_url).path
    else
      raise ActionController::RoutingError, 404
    end
  end

  def sagas_for_left_nav
    @sagas_for_left_nav = policy_scope Saga.order(:sequence_number)
  end

  def main_menu_categories
    category_names = %w[Games Gallery More]
    @main_menu_categories =
      CategoryPolicy::Scope
        .new(
          current_user,
          Category.where(name: category_names).includes(:categorisations)
        )
        .resolve
        .sort_by { |category| category_names.index(category.name) }
  end

  # Disable the session cookie unless you were going to a page with Devise (e.g.
  # to sign up or log in, which will require a non-tracking cookie for CSRF
  # protection) or are already signed in. Adapted from Ryan Baumann's post:
  # https://ryanfb.github.io/etc/2021/08/29/going_cookie-free_with_rails.html
  def conditionally_set_session_cookie
    unless user_signed_in?
      cookies.delete(Rails.application.config.session_options[:key])
    end
    request.session_options[:skip] = !(user_signed_in? || devise_controller?)
  end

  # This allows all records to be displayed in a Ransack search when 'Drafts
  # Only' is unchecked.
  def clean_publish_false_param
    if params[:q]
      params[:q].delete_if { |k, v| k == 'publish_false' && v == '0' }
    end
  end
end
