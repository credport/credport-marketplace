Rails.configuration.credport_key = 'f241a046aa2016f29040808d99686a162c52f4e52b0b1671063f064358de96d2'
Rails.configuration.credport_secret = '513b764206d039ef89f23479e3e4cf0df58064acbc6a71dd5b31c826f3e3f909'

Rails.configuration.credport_identity_context_name = 'credport-examplemarketplace'
Rails.configuration.credport_review_context_name = 'credport-review'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :credport, Rails.configuration.credport_key, Rails.configuration.credport_secret
end