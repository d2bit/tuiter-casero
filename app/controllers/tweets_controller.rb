class TweetsController < ApplicationController
  before_action :authenticate, except: %i(homepage)
  before_action :set_twitter_client, only: %i(index create)

  def homepage
    redirect_to timeline_path if current_user.present?
  end

  def index
  end

  def new
  end

  def create
    @tw_client.post(params['text'], params['media'])

    redirect_to timeline_path
  end

  private

  def set_twitter_client
    @tw_client ||= TwClient.new(current_user['token'], current_user['secret'])
  end

  def authenticate
    return if current_user

    flash[:warning] = 'You should be authenticated!'
    redirect_to root_path
  end
end
