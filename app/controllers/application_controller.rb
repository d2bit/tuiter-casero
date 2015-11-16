class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    session[:oauth]
  end

  def remove_authentication
    session.delete :oauth
    redirect_to root_path
  end
end
