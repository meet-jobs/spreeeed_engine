module SpreeeedEngine
  module RoutesHelper

    def klass_name
      @klass.name.underscore
    end

    def resources
      pluralize?(klass_name) ? klass_name.pluralize : "#{klass_name}_index"
    end

    def resource
      klass_name
    end

    def new_object_path(opts={})
      send("new_#{SpreeeedEngine.namespace}_#{resource}_path", opts)
    end

    def objects_path(opts={})
      send("#{SpreeeedEngine.namespace}_#{resources}_path", opts)
    end

    def object_path(object, opts={})
      _klass_name = object.class.name.underscore
      _resources  = _klass_name == klass_name ? resources : _klass_name

      send("#{SpreeeedEngine.namespace}_#{_resources}_path", object, opts)
    end

    def edit_object_path(object, opts={})
      send("edit_#{SpreeeedEngine.namespace}_#{resources}_path", object, opts)
    end

  end
end
