module SpreeeedEngine
  module Input
    module InterfaceHelper
      extended SpreeeedEngine::Input::BaseHelper

      def render_gender_input(klass, attr, form_object)
        render_radio_input(klass, attr, form_object, [I18n.t('male'), I18n.t('female')])
      end

      def render_custom_input(klass, attr, form_object)
        nil
      end

      def render_input(klass, attr, form_object)
        custom_input = render_custom_input(klass, attr, form_object)
        return custom_input if custom_input.present?

        if (association = belongs_to_association(klass, {foreign_key: attr.to_s}))
          return render_association_input(klass, attr, form_object, association)
        end

        type = klass.columns_hash[attr.to_s].type rescue :string

        case type
          when :datetime
            render_datetime_input(klass, attr, form_object)
          when :date
            render_date_input(klass, attr, form_object)
          when :time
            render_time_input(klass, attr, form_object)
          when :text
            render_textarea_input(klass, attr, form_object)
          when :boolean
            render_switch_input(klass, attr, form_object)
          when :string
            if defined?(AASM) && klass.try(:aasm) && (klass.aasm.state_machine.config.column == attr)
              return render_aasm_input(klass, attr, form_object)
            end
            case attr.to_sym
              # when :name
                # render_auto_complete_input(klass, attr, form_object, {query_path: "/#{SpreeeedEngine.namespace}/scratch/typeahead_data"})
              # when :filename
              #   render_file_input(klass, attr, form_object)
              when :asset
                render_image_input(klass, attr, form_object)
              when :gender
                render_gender_input(klass, attr, form_object)
              else
                if klass.respond_to?(attr.to_s.pluralize.to_sym)
                  collection = klass.send(attr.to_s.pluralize.to_sym)

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
