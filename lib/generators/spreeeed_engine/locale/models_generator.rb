module SpreeeedEngine
  module Locale
    module Generators
      class ModelsGenerator < Rails::Generators::Base

        desc <<-DESC.strip_heredoc
          Generate all locale files of models (app-scope)

          For example:
            rails generate spreeeed_engine:locales:models LANG

            This will create:
              config/locales/models/*/*/LANG.yml

            real world case:
              rails g spreeeed_engine:locales:models zh-TW

            then you can find local file in 
              config/locales/models/user/zh-TW.yml
              config/locales/models/article/zh-TW.yml
              ...

        DESC

        argument :lang, type: :string, default: 'en'

        def create_locale_files
          Rails.application.eager_load!
          model_names = ApplicationRecord.descendants.map(&:name)
          model_names.each do |model_name|
            generate "locales:model #{model_name} #{lang}"
          end
        end
      end
    end
  end
end
