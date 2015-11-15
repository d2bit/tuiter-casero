class TweetsController < ApplicationController
  before_action :authenticate, only: %i(new create)

  def index
    return render '_homepage' unless current_user

    user = tw_client.user
    @name = user.name
    @avatar_url = user.profile_image_url
    @tweets_count = user.tweets_count
    @tweets = tw_client.user_timeline
  end

  def new
  end

  def create
    if params['media'].present?
      tw_client.update_with_media(params['text'], params['media'])
    else
      tw_client.update(params['text'])
    end

    redirect_to root_path
  end

  private

  def tw_client
    secrets = Rails.application.secrets
    @tw_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = secrets[:tw_consumer_key]
      config.consumer_secret = secrets[:tw_consumer_secret]
      config.access_token = current_user['token']
      config.access_token_secret = current_user['secret']
    end
  end

  def authenticate
    return if current_user

    flash[:warning] = 'You should be authenticated!'
    redirect_to root_path
  end
end
