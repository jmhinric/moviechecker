class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def authenticate
    unless logged_in?
      store_location
      redirect_to login_path
    end
  end

  def authorize
    if current_user != @user && !logged_in?
      deny_access
      redirect_to login_path
    elsif current_user != @user
      flash[:notice] = "Authorization failed"
      redirect_to root_path
    end
  end

  def admin_authorize
    if current_user != User.find(@company.admin) && !logged_in?
      redirect_to login_path
    elsif current_user != User.find(@company.admin)
      redirect_to root_path
    end
  end

  helper_method :current_user, :logged_in?, :authenticate, :authorize, :admin_authorize

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
