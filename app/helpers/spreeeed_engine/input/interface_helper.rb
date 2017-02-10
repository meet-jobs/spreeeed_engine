module SpreeeedEngine
  module Input
    module InterfaceHelper
      extended SpreeeedEngine::Input::BaseHelper

      def render_gender_input(klass, attr, form_object)
        render_radio_input(klass, attr, form_object, [I18n.t('male'), I18n.t('female')])
      end

      def render_input(klass, attr, form_object)
        if (association = belongs_to_association(klass, {foreign_key: attr.to_s}))
          return render_association_input(klass, attr, form_object, association)
        end

        type = klass.columns_hash[attr.to_s].type rescue :string

        case type
          when :datetime
            render_datetime_input(klass, attr, form_object)
          when :date
            render_date_input(klass, attr, form_object)
          when :text
            render_text_input(klass, attr, form_object)
          when :string
            case attr.to_sym
              when :filename
                render_file_input(klass, attr, form_object)
              when :asset
                render_image_input(klass, attr, form_object)
              when :gender
                render_gender_input(klass, attr, form_object)

              else
                if klass.respond_to?(attr.to_s.pluralize.to_sym)
                  collection = klass.send(attr.to_s.pluralize.to_sym)

                  if attr.to_s == 'aasm_state'
                    mapping = []
                    collection.each do |item|
                      object = form_object.object
                      mapping << [I18n.t("activerecord.attributes.#{object.class.to_s.underscore}.states.#{attr.to_s}.#{item}"), item]
                    end
                    collection = mapping
                    Rails.logger.debug("=== collection = #{collection}")
                  end

                  render_select_input(klass, attr, form_object, collection)
                else
                  render_general_input(klass, attr, form_object)
                end
            end
          else
            render_general_input(klass, attr, form_object)
        end

      end

    end
  end
end
