$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'spreeeed_engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'spreeeed_engine'
  s.version     = SpreeeedEngine::VERSION
  s.authors     = ['Bruce Sung']
  s.email       = ['isfore@gmail.com']
  s.homepage    = 'http://midnightblue.github.com'
  s.summary     = 'Summary of SpreeeedEngine.'
  s.description = 'Description of SpreeeedEngine.'
  s.license     = 'MIT'

  s.files       = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.1'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'devise'
  s.add_dependency 'simple_form'
  s.add_dependency 'cocoon'
  s.add_dependency 'aasm'
  s.add_dependency 'carrierwave'
  s.add_dependency 'mini_magick'
  s.add_dependency 'will_paginate-bootstrap'
  s.add_dependency 'wysiwyg-rails'

  # View components for Ruby and Rails.
  s.add_dependency 'cells-rails'
  s.add_dependency 'cells-erb'


  # Stylesheets
  s.add_dependency 'rails-assets-font-awesome'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'rails-assets-jasny-bootstrap'
  s.add_dependency 'rails-assets-jquery.gritter'
  s.add_dependency 'rails-assets-moment'
  s.add_dependency 'rails-assets-parsleyjs'
  s.add_dependency 'rails-assets-jquery-ui'
  s.add_dependency 'rails-assets-datatables'
  s.add_dependency 'rails-assets-icheck'
  s.add_dependency 'rails-assets-bootstrap3-datetimepicker'
  s.add_dependency 'rails-assets-bootstrap-switch'
  s.add_dependency 'rails-assets-fuelux'
  s.add_dependency 'rails-assets-jquery.cookie'
  s.add_dependency 'rails-assets-jPushMenu'
  s.add_dependency 'rails-assets-nanoscroller'
  s.add_dependency 'rails-assets-select2'
  s.add_dependency 'rails-assets-select2-bootstrap3-css'
  s.add_dependency 'rails-assets-jquery-option-tree'
  s.add_dependency 'rails-assets-bootstrap3-typeahead'
  s.add_dependency 'rails-assets-input-autogrow'
  s.add_dependency 'rails-assets-dirrty'
  s.add_dependency 'rails-assets-typeahead.js'
  s.add_dependency 'rails-assets-bootstrap-tagsinput'


end
