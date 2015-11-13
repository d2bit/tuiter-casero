class TweetsController < ApplicationController
  def index
    return redirect_to logout_path unless current_user
  end
end
