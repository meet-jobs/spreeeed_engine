SpreeeedEngine.setup do |config|
  config.devise_auth_resource = 'user'
  config.namespace            = '<%= @spreeeed_engine_namespace %>'
  config.locale               = :en
end
