module SpreeeedEngine
  module Locales
    module Generators
      class ModelGenerator < Rails::Generators::NamedBase
      
        desc <<-DESC.strip_heredoc
          Generate locale file of a single model

          For example:
            rails generate spreeeed_engine:locales:model NAME LANG

            This will create:
              config/locales/models/NAME/LANG.yml

            real world case:
              rails g spreeeed_engine:locales:model user zh-TW

            then you can find local file in 
              config/locales/models/user/zh-TW.yml

            and all attributes will be preset in YAML file, you just need
            to translate them.

            This generator also support model with namespace, say
              rails g spreeeed_engine:locales:model user::address zh-TW

            then you can find local file in 
              config/locales/models/user/address/zh-TW.yml

        DESC

        source_root File.expand_path('../templates', __FILE__)

        argument :lang, type: :string, default: 'en'

        # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html
        def create_locale_file
          klass        = Object.const_get(name) rescue name.titleize.gsub(/\s+/, '').classify.constantize
          @model_name  = klass.name.titleize.singularize.downcase.gsub(/\s+/, '_')
          @columns     = klass.column_names
          template 'en.yml',
                   "config/locales/models/#{@model_name}/#{lang}.yml"
          # assigns: { model_name: @model_name, lang: lang, columns: @columns }
        end
      end
    end
  end
end

