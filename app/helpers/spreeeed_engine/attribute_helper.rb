module SpreeeedEngine
  module AttributeHelper

    def humanize_identifiers
      %w(name title subject caption).map(&:to_sym)
    end

    def primary_humanize_identifiers
      [:id] + humanize_identifiers
    end

    def custom_datatable_cell_value(object, attr)
      nil
    end

    def datatable_cell_value(object, attr)
      return nil if object.nil? || object.new_record?

      custom_cell_value = custom_datatable_cell_value(object, attr)
      return custom_cell_value if custom_cell_value.present?

      value = object.send(attr.to_sym)

      if primary_humanize_identifiers.include?(attr)
        return link_to(value, object_path(object), {:target => '_blank'})
      end

      if belongs_to_association?(object.class, {name: attr.to_s})
        humanize_identifiers.each do |related_object_name|
          if value.respond_to?(related_object_name)
            return datatable_cell_value(value, related_object_name)
          end
        end
        return datatable_cell_value(value, :id)
      end

      if defined?(CarrierWave::Uploader::Base) && value.kind_of?(CarrierWave::Uploader::Base)
        if value.class.const_defined? 'MiniMagick'
          return asset_image_tag(value, [:datatable, :square])
        end
        return nil
      end

      if object.class.try(attr.to_s.pluralize.to_sym) || (defined?(AASM) && object.class.try(:aasm) && (object.class.aasm.state_machine.config.column == attr))
        i18n_key = "#{attr}/#{value}".to_sym
        return object.class.human_attribute_name(i18n_key)
      end

      if attr == :email
        return mail_to(value)
      end

      if attr == :phone
        return tel_to(value)
      end

      if attr == :password
        return password_mask(value)
      end

      if object.class.columns_hash[attr.to_s].type == :text
        return simple_format(value)
      end

      format_value(value)
    end

    def display_attribute(object, attr)
      value = object.send(attr.to_sym)

      if defined?(CarrierWave::Uploader::Base) && value.kind_of?(CarrierWave::Uploader::Base)
        if value.class.const_defined? 'MiniMagick'
          return asset_image_tag(value, [:datatable, :landscape])
        end
        return nil
      end

      datatable_cell_value(object, attr)
    end

    def tel_to(text)
      groups = text.to_s.scan(/(?:^\+)?\d+/)
      if groups.size > 1 && groups[0][0] == '+'
        # remove leading 0 in area code if this is an international number
        groups[1] = groups[1][1..-1] if groups[1][0] == '0'
        groups.delete_at(1) if groups[1].size == 0 # remove if it was only a 0
      end
      link_to text, "tel:#{groups.join '-'}"
    end

    def password_mask(pwd)
      pwd.gsub(/./, '*')
    end

    def format_value(value)
      case value
        when String
          value
        when Integer || BigDecimal || Fixnum
          number_with_delimiter(value)
        when ActiveSupport::TimeWithZone
          value.strftime('%Y-%m-%d %H:%M:%S')
        when Date
          value.strftime('%Y-%m-%d')
        when Time
          value.strftime('%H:%M:%S')
        when TrueClass
          true_or_false(value)
        when FalseClass
          true_or_false(value)
        else
          value
      end
    end

    def display_state(object, attr)
      I18n.t("activerecord.attributes.#{object.class.to_s.underscore}.states.#{attr.to_s}.#{object.send(attr)}")
    end

    def true_or_false(flag)
      css   = flag ? 'fa-check' : 'fa-times'
      color = flag ? '#19B698' : '#EA6153'
      content_tag(:div, '', class: ['fa', css], style: "color: #{color};")
    end

    def asset_image_tag(asset, versions=[], html_options={})
      _asset = asset
      versions.each do |version|
        _asset = _asset.send(version.to_sym)
      end
      url = _asset.url
      image_tag(url, html_options)
    end

    def object_name(object)
      %w(name title subject caption).each do |attr|
        if object.respond_to?(attr.to_sym)
          return object.send(attr.to_sym)
        end
      end
      %Q|#{object.class.model_name.human} - #{object.id}|
    end

  end
end
