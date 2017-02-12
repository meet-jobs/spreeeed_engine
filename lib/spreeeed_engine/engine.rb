module SpreeeedEngine
  require 'spreeeed_engine/active_record_extension'
  require 'spreeeed_engine/datatable_cell'
  require 'spreeeed_engine/datatable_extension'
  require 'spreeeed_engine/regexp_to_js'
  require 'spreeeed_engine/aasm_run_time'

  require 'devise'
  require 'simple_form'
  require 'cocoon'
  require 'aasm'



  # require 'rails-assets-fontawesome'
  require 'rails-assets-bootstrap-sass'
  require 'rails-assets-jquery.gritter'
  require 'rails-assets-jasny-bootstrap'
  # require 'parsley-rails'
  require 'rails-assets-parsleyjs'
  require 'rails-assets-jquery-ui'
  require 'rails-assets-datatables'
  require 'rails-assets-icheck'
  require 'rails-assets-bootstrap3-datetimepicker'
  require 'rails-assets-moment'
  require 'rails-assets-bootstrap-daterangepicker'
  require 'rails-assets-bootstrap-switch'
  require 'rails-assets-fuelux'
  require 'rails-assets-jquery.cookie'
  require 'rails-assets-jPushMenu'
  require 'rails-assets-nanoscroller'
  require 'rails-assets-select2'
  require 'rails-assets-select2-bootstrap3-css'
  # require 'rails-assets-bs-slider'
  require 'rails-assets-jquery-option-tree'



  class << self
    mattr_accessor :devise_auth_resource, :namespace, :locale, :path
    self.devise_auth_resource = 'user'
    self.namespace            = 'admin'
    self.locale               = :en
  end

  def self.setup(&block)
    yield self
  end


  class Engine < ::Rails::Engine
    engine_name 'spreeeed_engine'

    config.time_zone = 'Taipei'

    config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    SpreeeedEngine.path = config.i18n.load_path
    # config.i18n.available_locales ||= [:en, :'zh-TW']
    config.i18n.default_locale = SpreeeedEngine.locale
    # config.action_controller.include_all_helpers = false


    initializer 'SpreeeedEngine.assets.precompile' do |app|
      app.config.assets.precompile += %w(spreeeed_engine/ajax-loader.gif)
    end

    Devise.parent_controller = 'SpreeeedEngine::Devise::ParentController'

    isolate_namespace SpreeeedEngine
  end
end
