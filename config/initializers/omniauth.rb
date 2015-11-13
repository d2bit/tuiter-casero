Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    Rails.application.secrets[:tw_consumer_key],
    Rails.application.secrets[:tw_consumer_secret]
end
