class TweetsController < ApplicationController
  def index
    return render '_homepage' unless current_user

    user = tw_client.user
    @name = user.name
    @avatar_url = user.profile_image_url
    @tweets_count = user.tweets_count
    @tweets = tw_client.user_timeline
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
end
