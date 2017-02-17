module SpreeeedEngine
  module Input
    module BaseHelper

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

        html_options
      end

      def render_hidden_input(klass, attr, form_object, html_options={})
        form_object.hidden_field attr.to_sym, {:value => form_object.object.send(attr.to_sym)}
      end

      def render_general_input(klass, attr, form_object, html_options={})
        name = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => 'form-group' do
          content = content_tag :label, :class => 'col-sm-3 control-label', :for => name do
            klass.human_attribute_name(attr.to_sym)
          end

          content += content_tag :div, :class => 'col-sm-7' do
            sub_content = content_tag :div, :class => 'input-group' do
              form_object.input_field attr.to_sym, bind_validators(klass, attr).merge(html_options)
            end
            sub_content += content_tag :div, :id => "#{name}-error" do
            end

            sub_content
          end

          content
        end
      end

      def render_text_input(klass, attr, form_object, html_options={})
        name = [klass.name.underscore, attr].join('_')
        html_options.merge!({cols: 60, rows: 10, class: 'form-control autogrow', 'data-plus-as-tab': 'false'})

        content_tag :div, :class => 'form-group' do
          content = content_tag :label, :class => 'col-sm-3 control-label', :for => name do
            klass.human_attribute_name(attr.to_sym)
          end

          content += content_tag :div, :class => 'col-sm-6' do
            sub_content = form_object.input_field attr.to_sym, bind_validators(klass, attr).merge(html_options)
            # sub_content += content_tag :div, :id => "#{name}-error" do
            # end

            sub_content
          end

          content
        end
      end

      def render_radio_input(klass, attr, form_object, collection)
        id = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => "form-group" do
          c1 = content_tag :label, :class => "col-sm-3 control-label", :for => id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => "col-sm-6" do
            collection.collect do |item|
              content_tag :label, :class => 'radio-inline' do
                html_options = {:class => 'icheck', :type => 'radio', :value => item, :style => "position: absolute; opacity: 0;"}
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
        id = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            # <div class="switch switch-mini has-switch">
            #   <div class="switch-animate switch-on">
            #     <input type="checkbox" checked="">
            #     <span class="switch-left switch-mini">ON</span>
            #     <label class="switch-mini">&nbsp;</label>
            #     <span class="switch-right switch-mini">OFF</span></div>
            # </div>
            content_tag :div, :class => 'has-switch' do
              form_object.input_field(attr.to_sym, as: :boolean, boolean_style: :inline)
            end.html_safe

            # collection.collect do |item|
            #   content_tag :label, :class => 'radio-inline' do
            #     html_options = {:class => 'icheck', :type => 'radio', :value => item, :style => "position: absolute; opacity: 0;"}
            #     if form_object.object.send(attr.to_sym) == item
            #       html_options.merge!({:checked => 'checked'})
            #     end
            #     html_options = bind_validators(klass, attr).merge(html_options)
            #     form_object.input_field(attr.to_sym, html_options) + ' ' + item
            #   end
            # end.join(' ').html_safe
          end

          c1
        end
      end

      def render_select_input(klass, attr, form_object, collection)
        id = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => "form-group" do
          c1 = content_tag :label, :class => "col-sm-3 control-label", :for => id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => "col-sm-6" do
            content_tag :div, :class => "input-group" do
              html_options = bind_validators(klass, attr).merge({:collection => collection})
              form_object.input_field(attr.to_sym, html_options)
            end
          end

          c1
        end
      end

      def render_tags_input(klass, attr, form_object, tags=0)
        id = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => "form-group" do
          c1 = content_tag :label, :class => "col-sm-3 control-label", :for => id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => "col-sm-6" do
            content_tag :div, :class => "input-group" do
              html_options = bind_validators(klass, attr).merge({:class => 'tags'})
              form_object.hidden_field(attr.to_sym, html_options)
            end
          end

          c1 += %Q|
<script>
  $(document).ready(function() {
    $("##{id}").select2({
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
        id = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => id do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => 'col-sm-6' do
            content_tag :div, :class => 'input-group' do
              html_options = bind_validators(klass, attr).merge({:class => "#{id.__id__} form-control", :style => 'width: 300px;'})
              form_object.input_field(attr.to_sym, html_options)
            end
          end

          if options[:collection]
            c1 += %Q|
<script>
  $(document).ready(function() {
    $(".#{id.__id__}").select2({
      placeholder: '#{I18n.t('select_one')}',
      width: 'resolve',
      minimumInputLength: 1,
      data: #{options[:collection].to_json},
    });
  });
</script>
|.html_safe
          else
            c1 += %Q|
<script>
  $(document).ready(function() {
    $("##{id}").select2({
      placeholder: '#{I18n.t('select_one')}',
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

      def render_association_input(klass, attr, form_object, association, label_method=:name)
        collection  = association.class_name.camelize.constantize.all.collect { |item| [item.send(label_method), item.id] }
        render_select_input(klass, attr, form_object, collection)
      end

      def render_datetime_input(klass, attr, form_object, options={ruby_time_format: '%Y-%m-%d %H:%M:%S', js_time_format: 'YYYY-MM-DD HH:mm:ss', css_selector: 'se-datetime', icon_class: 'fa fa-calendar'})
        name = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => 'form-group' do
          c1 = content_tag :label, :class => 'col-sm-3 control-label', :for => name do
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
            c2 += content_tag :div, :id => "#{name}-error" do
            end

            c2
          end

          c1
        end
      end

      def render_date_input(klass, attr, form_object)
        render_datetime_input(klass, attr, form_object, {ruby_time_format: '%Y-%m-%d', js_time_format: 'YYYY-MM-DD', css_selector: 'se-date', icon_class: 'fa fa-calendar'})
      end

      def render_time_input(klass, attr, form_object)
        render_datetime_input(klass, attr, form_object, {ruby_time_format: '%H:%M:%S', js_time_format: 'HH:mm:ss', css_selector: 'se-time', icon_class: 'fa fa-clock-o'})
      end

      def render_image_input(klass, attr, form_object)
        name = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => "form-group" do
          c1 = content_tag :label, :class => "col-sm-3 control-label", :for => name do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => "col-sm-6" do
            c2 = content_tag :div, :'data-provides' => 'fileinput', :class => "fileinput fileinput-new" do
              c3 = ''
              if (url = form_object.object.send(attr.to_sym).url)
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
                    I18n.t('choose_photo')
                  end
                  c5 += content_tag :span, :class => 'fileinput-exists' do
                    I18n.t('change')
                  end
                  c5 += form_object.input_field attr.to_sym, bind_validators(klass, attr, {:accept => "image/*", :class => ""})
                  c5
                end
                c4 += content_tag :a, :'data-dismiss' => 'fileinput', :class => 'btn btn-danger fileinput-exists' do
                  I18n.t('remove_photo')
                end
                c4
              end
              c3.html_safe
            end
            c2 += content_tag :div, :id => "#{name}-error" do
            end

            c2
          end

          c1
        end
      end

      def render_file_input(klass, attr, form_object)
        name = [klass.name.underscore, attr].join('_')

        content_tag :div, :class => "form-group" do
          c1 = content_tag :label, :class => "col-sm-3 control-label", :for => name do
            klass.human_attribute_name(attr.to_sym)
          end

          c1 += content_tag :div, :class => "col-sm-6" do
            c2 = content_tag :div, :'data-provides' => 'fileinput', :class => "fileinput fileinput-new" do
              c3 = ''
              if (url = form_object.object.send(attr.to_sym).url)
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
                    I18n.t('choose_file')
                  end
                  c5 += content_tag :span, :class => 'fileinput-exists' do
                    I18n.t('change')
                  end
                  c5 += form_object.input_field attr.to_sym, bind_validators(klass, attr, {:class => ""})
                  c5
                end
                c4 += content_tag :a, :'data-dismiss' => 'fileinput', :class => 'btn btn-danger fileinput-exists' do
                  I18n.t('remove_file')
                end
                c4
              end
              c3.html_safe
            end
            c2 += content_tag :div, :id => "#{name}-error" do
            end

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

    end
  end
end
