class TwClient
  def initialize(token, secret)
    secrets = Rails.application.secrets
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = secrets.tw_consumer_key
      config.consumer_secret = secrets.tw_consumer_secret
      config.access_token = token
      config.access_token_secret = secret
    end
  end

  def name
    @client.user.name
  end

  def avatar_url
    @client.user.profile_image_url
  end

  def tweets_count
    @client.user.tweets_count
  end

  def pages_count
    (tweets_count / 20.0).ceil
  end

  def tweets(options = {})
    @client.user_timeline(options)
  end

  def post(text, media = nil)
    post_media(text, media) or post_text(text)
  end

  protected

  def post_text(text)
    return unless text.present?

    @client.update(text)
  end

  def post_media(text, media = nil)
    return unless media.present?

    @client.update_with_media(text, media)
  end
end
