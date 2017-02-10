module SpreeeedEngine
  module Route
    module Generators

      class MountGenerator < Rails::Generators::Base
        # include Rails::Generators::ResourceHelpers

        class_option :routes, desc: "Generate routes", type: :boolean, default: true

        desc 'This generator mount spreeeed engine at config/routes.rb'
        def add_spreeeed_engine_routes
          route %Q|mount SpreeeedEngine::Engine => "/\#{SpreeeedEngine.namespace}", as: SpreeeedEngine.namespace.to_sym|
        end

      end

    end
  end
end

