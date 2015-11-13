class SessionsController < ApplicationController
  def create
    session[:oauth] = auth_hash.credentials.to_hash
    redirect_to root_path
  end

  def destroy
    session.delete :oauth
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
