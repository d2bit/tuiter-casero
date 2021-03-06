class TweetsController < ApplicationController
  before_action :authenticate, except: %i(homepage)
  before_action :set_twitter_client, only: %i(index create)

  rescue_from Twitter::Error::Unauthorized, with: :remove_authentication

  def homepage
    redirect_to timeline_path if current_user.present?
  end

  def index
    options = {}
    page = params[:page].to_i
    options[:page] = page if page > 1
    @tweets = @tw_client.tweets(options)
    @name = @tw_client.name
    @avatar_url = @tw_client.avatar_url

    @paginator = Paginator.new(page, @tw_client.pages_count)
  end

  def new
  end

  def create
    @tw_client.post(params['text'], params['media'])

    flash[:success] = 'New tweet posted! =)'
    redirect_to timeline_path
  end

  private

  def set_twitter_client
    @tw_client ||= TwClient.new(current_user['token'], current_user['secret'])
  end

  def authenticate
    return if current_user

    flash[:danger] = 'You should be authenticated!'
    redirect_to root_path
  end
end
