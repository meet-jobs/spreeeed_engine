module SpreeeedEngine
  module EngineRouteController
    extend ActiveSupport::Concern

    included do
      include SpreeeedEngine::UtilityHelper

      helper_method :klass_name,
                    :resources,
                    :resource,
                    :new_object_path,
                    :objects_path,
                    :object_path,
                    :edit_object_path
    end

    def klass_name
      @klass.name.demodulize.underscore
    end

    def resources
      pluralize?(klass_name) ? klass_name.pluralize : "#{klass_name}_index"
    end

    def resource
      klass_name
    end

    def new_object_path(opts={})
      # Rails.logger.debug("***** #{polymorphic_url(@klass.new)}")
      SpreeeedEngine::Engine.routes.url_helpers.send("new_#{resource}_path", opts)
    end

    def objects_path(opts={})
      SpreeeedEngine::Engine.routes.url_helpers.send("#{resources}_path", opts)
    end

    def object_path(object, opts={})
      SpreeeedEngine::Engine.routes.url_helpers.send("#{resource}_path", object, opts)
    end

    def edit_object_path(object, opts={})
      SpreeeedEngine::Engine.routes.url_helpers.send("edit_#{resource}_path", object, opts)
    end

  end
end
