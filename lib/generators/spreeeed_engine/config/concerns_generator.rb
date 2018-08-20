module SpreeeedEngine
  module Config
    module Generators
      class ConcernsGenerator < Rails::Generators::NamedBase
      
        desc <<-DESC.strip_heredoc
          Generate spreeeed_engine active_record extend attributes

          For example:
            rails generate spreeeed_engine:concerns:model NAME

            This will create:
              app/models/concerns/spreeeed_engine/models/NAME.rb

            real world case:
              rails g spreeeed_engine:concerns:model Manuscript::Photo

            then you can find file in 
              app/models/concerns/spreeeed_engine/models/manuscript/photo.rb

        DESC

        source_root File.expand_path('../templates', __FILE__)

        def create_concern_model
          @klass       = Object.const_get(name) rescue name.titleize.gsub(/\s+/, '').gsub('/', '::').classify.constantize
          folder_name  = @klass.name.titleize.singularize.downcase.gsub(/\s+/, '_')
          @namespaces  = folder_name.split('/').map(&:titleize).collect{ |e| e.delete(' ') }
          @indent      = '  ' * (@namespaces.size + 2)
          @methods     = [:displayable_attrs, :editable_attrs, :hidden_attrs]
          template 'model.rb',
                   "app/models/concerns/spreeeed_engine/models/#{folder_name}.rb"
        end

        def create_concern_datatable
          @klass       = Object.const_get(name) rescue name.titleize.gsub(/\s+/, '').gsub('/', '::').classify.constantize
          folder_name   = @klass.name.titleize.singularize.downcase.gsub(/\s+/, '_')
          @namespaces  = folder_name.split('/').map(&:titleize).collect{ |e| e.delete(' ') }
          @indent      = '  ' * (@namespaces.size + 2)
          @methods     = [:datatable_cols, :datatable_searchable_cols, :datatable_sortable_cols, :datatable_default_sortable_cols]
          template 'datatable.rb',
                   "app/models/concerns/spreeeed_engine/datatables/#{folder_name}.rb"
        end

      end
    end
  end
end

