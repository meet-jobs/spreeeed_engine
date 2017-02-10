module SpreeeedEngine
  module Config
    module Generators

      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)
        argument :spreeeed_engine_namespace, :type => :string, :default => 'admin'

        desc 'This generator creates a spreeeed_engine config file at config/initializers, default spreeeed_engine namespace is admin'
        def create_install_file
          template 'spreeeed_engine.rb', 'config/initializers/spreeeed_engine.rb'
        end

      end

    end
  end
end

