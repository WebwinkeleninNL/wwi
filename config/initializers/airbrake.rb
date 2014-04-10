
Airbrake.configure do |config|
  config.api_key = '45ce6527963775ef500d6ec8ec7b10fb'
  config.host    = 'errbit.webwinkelenin.nl'
  config.port    = 80
  config.secure  = config.port == 443
end
