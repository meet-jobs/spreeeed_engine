module SpreeeedEngine
  module Input
    module BaseHelper

      def attr_identifier(klass, attr)
        [klass.name.demodulize.underscore, attr].join('_')
      end

      def bind_validators(klass, attr, html_options={:class => 'form-control'})
        #
        # ref: http://parsleyjs.org/doc/index.html
        # using ParsleyJS binding Rails ActiveRecord Validations
        #
        validators = klass.validators_on(attr.to_sym)
        return html_options if validators.empty?

        validators.each do |validator|
          case validator
            when ActiveRecord::Validations::PresenceValidator
              html_options[:'data-parsley-required'] = true
            when ActiveRecord::Validations::LengthValidator
              minimum, maximum = validator.options[:minimum], validator.options[:maximum]
              if minimum && maximum
                html_options[:'data-parsley-length'] = "[#{minimum}, #{maximum}]"
              elsif minimum
                html_options[:'data-parsley-min'] = minimum
              elsif maximum
                html_options[:'data-parsley-max'] = maximum
              end
            when ActiveModel::Validations::NumericalityValidator
              only_integer = validator.options[:only_integer]
              html_options[:'data-parsley-type'] = only_integer ? 'integer' : 'digits'
            when ActiveModel::Validations::FormatValidator
              html_options[:'data-parsley-pattern'] = validator.options[:with].to_javascript
          end
        end

        html_options[:'data-parsley-errors-container'] = "##{attr_identifier(klass, attr)}-error"

        html_options
      end

      def render_hidden_input(klass, attr, form_object, html_options={})
        value = html_options[:value] || form_object.object.send(attr.to_sym)
        form_object.hidden_field attr.to_sym, {value: value}
      end

      def render_general_input(klass, attr, form_object, html_options={})
        attr_id = attr_identifier(klass, attr)
        html_options.merge!({class: 'form-control autogrow'})

        content_tag :div, :class => 'form-group' do
          content = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          content += content_tag :div, :class => 'col-sm-7' do
            sub_content = content_tag :div, :class => 'input-group' do
              form_object.input_field attr.to_sym, bind_validators(klass, attr).merge(html_options)
            end
            sub_content += content_tag(:div, '', :id => "#{attr_id}-error")

            sub_content
          end

          content
        end
      end

      def render_textarea_input(klass, attr, form_object, html_options={})
        attr_id = attr_identifier(klass, attr)
        html_options.merge!({cols: 60, rows: 10, class: 'form-control autogrow', 'data-plus-as-tab': 'false'})

        content_tag :div, :class => 'form-group' do
          content = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          content += content_tag :div, :class => 'col-sm-6' do
            sub_content = form_object.input_field attr.to_sym, bind_validators(klass, attr).merge(html_options)
            sub_content += content_tag(:div, '', :id => "#{attr_id}-error")

            sub_content
          end

          content
        end
      end

      def render_wysiwyg_input(klass, attr, form_object, html_options={}, froala_options={})
        attr_id = attr_identifier(klass, attr)
        value = form_object.object.send(attr.to_sym)
        value = value ? value.strip : ''
        html_options.merge!({
                            class: 'form-control',
                            # value: simple_format(form_object.object.send(attr.to_sym).strip, {}, :sanitize => false),
                            value: value,
                            })

        content_tag :div, :class => 'form-group' do
          content = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          content += content_tag :div, :class => 'col-sm-6' do
            sub_content = form_object.input_field attr.to_sym, bind_validators(klass, attr).merge(html_options)
            sub_content += content_tag(:div, '', :id => "#{attr_id}-error")

            sub_content
          end

          (content + %Q|<script>$(document).ready(function() { $("##{attr_id}").froalaEditor(#{froala_options.to_json}); });</script>|.html_safe)
        end
      end

      def render_radio_input(klass, attr, form_object, collection)
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            collection.collect do |item|
              content_tag :label, :class => 'radio-inline' do
                html_options = {:class => 'icheck', :type => 'radio', :value => item, :style => 'position: absolute; opacity: 0;' }
                if form_object.object.send(attr.to_sym) == item
                  html_options.merge!({:checked => 'checked'})
                end
                html_options = bind_validators(klass, attr).merge(html_options)
                form_object.input_field(attr.to_sym, html_options) + ' ' + item
              end
            end.join(' ').html_safe
          end

          c1
        end
      end

      def render_switch_input(klass, attr, form_object, options={default: false, size: 'normal', css_class: ''})
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            content_tag :div, :class => 'has-switch' do
              form_object.input_field(attr.to_sym, as: :boolean, boolean_style: :inline)
            end.html_safe
          end

          c1
        end
      end

      def render_select_input(klass, attr, form_object, collection)
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            content_tag :div, :class => 'input-group' do
              html_options = bind_validators(klass, attr).merge({:collection => collection})
              form_object.input_field(attr.to_sym, html_options)
            end
          end

          c1
        end
      end

      def render_tags_input(klass, attr, form_object, tags=[])
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            content_tag :div, :class => 'input-group' do
              html_options = bind_validators(klass, attr).merge({:class => 'tags'})
              form_object.hidden_field(attr.to_sym, html_options)
            end
          end

          c1 += %Q|
<script>
  $(document).ready(function() {
    $("##{attr_id}").select2({
      placeholder: 'Select an option',
      tags: #{tags.to_json},
      width: 'resolve',
    });
  });
</script>
|.html_safe

          c1
        end
      end


      def render_select2_input(klass, attr, form_object, options={collection: nil, query_path: nil})
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            c2 = content_tag :div, :class => 'input-group' do
              select2_options = {
                :class => "#{attr_id.__id__} select2 form-control",
                # :'data-placeholder' => I18n.t('operations.select_one'),
                # :'data-width' => 'resolve',
                # :'data-minimumInputLength' => 1,
                # :'data-data' => options[:collection].to_json,
              }
              html_options = bind_validators(klass, attr).merge({:style => 'width: 300px;'}).merge(select2_options)
              form_object.input_field(attr.to_sym, html_options)
            end
            c2 += content_tag(:div, '', :id => "#{attr_id}-error")
            c2
          end

          default_value = form_object.object.send(attr.to_sym)
          default_id    = options[:collection].select{ |item| item[:text] == default_value }.first[:id] rescue nil
          has_default_value = !default_id.nil?


          if options[:collection]
            c1 += (%Q|
<script>
  $(document).ready(function() {
    $(".#{attr_id.__id__}").select2({
      placeholder: '#{I18n.t('operations.select_one')}',
      width: 'resolve',
      minimumInputLength: 1,
      data: #{options[:collection].to_json},
    });
| + (has_default_value ? %Q|$(".#{attr_id.__id__}").val("#{default_id}").trigger("change");| : '') +
%Q|
  });
</script>
|).html_safe
          else
            c1 += %Q|
<script>
  $(document).ready(function() {
    $("##{attr_id}").select2({
      placeholder: '#{I18n.t('operations.select_one')}',
      width: 'resolve',
      minimumInputLength: 1,
      ajax: {
        url: "#{options[:query_path]}.json",
        data: function (term, page) {
          return {
            q: term
          };
        },
        results: function (data, page) {
          return {results: data};
        },
      }
    });
  });
</script>
|.html_safe
          end

          c1
        end
      end

      def render_auto_complete_input(klass, attr, form_object, options={collection: nil, query_path: nil})
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            c2 = content_tag :div, :class => 'input-group' do
              auto_complete_options = {
                'data-provide': 'typeahead',
                autocomplete: 'off'
              }
              html_options = bind_validators(klass, attr).merge(auto_complete_options)
              form_object.input_field(attr.to_sym, html_options)
            end
            c2 += content_tag(:div, '', :id => "#{attr_id}-error")
            c2
          end

          if options[:collection]
            c1 += (%Q|
<script>
  $(document).ready(function() {
    $("##{attr_id}").typeahead({
      source: #{options[:collection].to_json},
    });
  });
</script>
|).html_safe
          else
            c1 += %Q|
<script>
  $(document).ready(function() {
    $("##{attr_id}").typeahead({
      source: function (query, process) {
        return $.get('#{options[:query_path]}.json', { query: query },
          function (data) {
            console.log(data);
            return process(data.options);
          }
        );
      }
    });
  });
</script>
|.html_safe
          end

          c1
        end
      end

      def render_association_input(klass, attr, form_object, association, label_method=:name)
        #
        # association.options[:polymorphic] == true
        # could not generate suitable input
        #
        raise "Polymorphic association #{klass.name} can not be determine specified model by #{attr}" if association.options[:polymorphic] == true
        collection  = association.class_name.camelize.constantize.all.collect { |item| [item.send(label_method), item.id] }
        render_select_input(klass, attr, form_object, collection)
      end

      def render_datetime_input(klass, attr, form_object, options={ruby_time_format: '%Y-%m-%d %H:%M:%S', js_time_format: 'YYYY-MM-DD HH:mm:ss', css_selector: 'se-datetime', icon_class: 'far fa-calendar-alt'})
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          default_datetime = form_object.object.send(attr.to_sym).strftime(options[:ruby_time_format]) rescue Time.zone.now.strftime(options[:ruby_time_format])

          c1 += content_tag :div, :class => 'col-sm-6' do
            c2 = content_tag :div, :'data-datetime-format' => options[:js_time_format], :class => "input-group #{options[:css_selector]} col-md-6 col-xs-7" do
              c3 = form_object.input_field attr.to_sym, bind_validators(klass, attr, {:class => 'form-control', :as => :string, :value => default_datetime})
              c3 += content_tag :span, :class => 'input-group-addon btn-primary' do
                content_tag :span, :class => options[:icon_class] do
                end
              end
              c3
            end
            c2 += content_tag(:div, '', :id => "#{attr_id}-error")

            c2
          end

          c1
        end
      end

      def render_date_input(klass, attr, form_object)
        render_datetime_input(klass, attr, form_object, {ruby_time_format: '%Y-%m-%d', js_time_format: 'YYYY-MM-DD', css_selector: 'se-date', icon_class: 'far fa-calendar-alt'})
      end

      def render_time_input(klass, attr, form_object)
        render_datetime_input(klass, attr, form_object, {ruby_time_format: '%H:%M:%S', js_time_format: 'HH:mm:ss', css_selector: 'se-time', icon_class: 'far fa-clock'})
      end

      def render_image_input(klass, attr, form_object)
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            c2 = content_tag :div, :'data-provides' => 'fileinput', :class => 'fileinput fileinput-new' do
              c3 = ''
              if (url = form_object.object.send(attr.to_sym).try(:url))
                c3 += content_tag :div, :class => 'fileinput-new thumbnail' do
                  content_tag :img, :src => url, :width => 200 do
                  end
                end
              end
              c3 += content_tag :div, :class => 'fileinput-preview fileinput-exists thumbnail', :style => 'max-width: 200px;' do
              end
              c3 += content_tag :div do
                c4 = content_tag :span, :class => 'btn btn-primary btn-file' do
                  c5 = content_tag :span, :class => 'fileinput-new' do
                    I18n.t('operations.choose_photo')
                  end
                  c5 += content_tag :span, :class => 'fileinput-exists' do
                    I18n.t('operations.change')
                  end
                  c5 += form_object.input_field attr.to_sym, bind_validators(klass, attr, {:accept => "image/*", :class => ""})
                  c5
                end
                c4 += content_tag :a, :'data-dismiss' => 'fileinput', :class => 'btn btn-danger fileinput-exists' do
                  I18n.t('operations.remove_photo')
                end
                c4
              end
              c3.html_safe
            end
            c2 += content_tag(:div, '', :id => "#{attr_id}-error")

            c2
          end

          c1
        end
      end

      def render_file_input(klass, attr, form_object)
        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            c2 = content_tag :div, :'data-provides' => 'fileinput', :class => 'fileinput fileinput-new' do
              c3 = content_tag :span, :class => 'btn btn-primary btn-file' do
                c4 = content_tag :span, :class => 'fileinput-new' do
                  I18n.t('operations.choose_file')
                end
                c4 += content_tag :span, :class => 'fileinput-exists' do
                  I18n.t('operations.change')
                end
                c4 += form_object.file_field attr.to_sym, bind_validators(klass, attr, {:class => ''})
                c4
              end
              c3 += content_tag(:span, '', :class => 'fileinput-filename')
              c3 += content_tag(:a, '', :'data-dismiss' => 'fileinput', :class => 'close fileinput-exists', :style => 'float: none')
              c3.html_safe
            end
            c2 += content_tag(:div, '', :id => "#{attr_id}-error")

            c2
          end

          c1
        end

      end

      def render_aasm_input(klass, attr, form_object)
        collection  = klass.aasm.states.collect do |state|
          i18n_key = "#{attr}/#{state.name}".to_sym
          [klass.human_attribute_name(i18n_key), state.name]
        end
        render_select_input(klass, attr, form_object, collection)
      end

      def render_option_tree_input(klass, attr, form_object, options={})
        default_options = {
          :as                 => :option_tree,
          :option_tree_config => {:choose => I18n.t('operations.choose')},
        }
        default_options[:klass]    = options[:klass]
        default_options[:sort_col] = options[:sort_col] if options[:sort_col]
        default_options[:sort_by]  = options[:sort_by] if options[:sort_by]

        input_html_options = options[:input_html] || {}
        input_html_options = default_options.merge(input_html_options)

        attr_id = attr_identifier(klass, attr)

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => attr_id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            content_tag :div, :class => 'input-group' do
              html_options = bind_validators(klass, attr).merge(input_html_options)
              form_object.input_field(attr.to_sym, html_options)
            end
          end

          c1
        end
      end

    end
  end
end
