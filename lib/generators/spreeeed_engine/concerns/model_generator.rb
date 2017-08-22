module SpreeeedEngine
  module Concerns
    module Generators
      class ModelGenerator < Rails::Generators::NamedBase
      
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

        def create_concern_file
          @klass       = name.titleize.classify.constantize
          model_name   = name.titleize.singularize.downcase
          @namespaces  = model_name.split('/')
          @indent      = '  ' * (@namespaces.size + 2)
          @methods     = [:displayable_attrs, :editable_attrs, :hidden_attrs]
          template 'model.rb',
                   "app/models/concerns/spreeeed_engine/models/#{model_name}.rb"
        end
      end
    end
  end
end

