module SpreeeedEngine
  module RoutesHelper
    mattr_accessor :_klass

    def klass_name
      if @_klass
        @_klass.name.underscore
      else
        @klass.name.underscore
      end
    end

    def resources
      _resources = pluralize?(klass_name) ? klass_name.pluralize : "#{klass_name}_index"
      _resources.gsub('/', '_')
    end

    def resource
      klass_name.gsub('/', '_')
    end

    def new_object_path(opts={})
      send("new_#{_object_path}", opts)
    end

    def objects_path(opts={})
      send(_objects_path, opts)
    end

    def object_path(object, opts={})
      send(_object_path, object, opts)
    end

    def edit_object_path(object, opts={})
      send("edit_#{_object_path}", object, opts)
    end

    def _object_path
      [SpreeeedEngine.namespace, resource, 'path'].compact.join('_')
    end

    def _objects_path
      [SpreeeedEngine.namespace, resources, 'path'].compact.join('_')
    end

  end
end
