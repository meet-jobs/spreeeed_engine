module SpreeeedEngine
  module Datatable
    module RenderHelper

      def render_sortable_cols(cols, sortable_cols)
        _sortable_cols = if sortable_cols.kind_of?(ActiveSupport::OrderedHash)
          sortable_cols.collect { |label, _cols| _cols }.flatten
        elsif sortable_cols.kind_of?(Array)
          sortable_cols
        end
        Rails.logger.debug("**** sortable_cols = #{_sortable_cols.inspect}")

        res = cols.collect { |col|
          {bSortable: _sortable_cols.include?(col)}
        }
        Rails.logger.debug("**** datatable sort options = #{res}")
        res
      end

      def render_default_sortable_cols(cols, default_sortable_cols)
        res = []
        default_sortable_cols.each do |sortable_col|
          if i = cols.index(sortable_col[0])
            res << [i, sortable_col[1]]
          end
        end
        res
      end

      def datatable_col_defs(object, attrs)
        res = []
        attrs.each do |attr|
          res << {
          :sTitle    => object.class.human_attribute_name(attr.to_sym),
          :bSortable => datatable_sortable(object, attr),
          }
        end
      end

      def search_box_placeholder(klass, searchable_cols)
        searchable_cols.collect do |col|
          klass.human_attribute_name(col.to_sym)
        end.join(', ')
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

      if has_many_association?(object.class, {name: attr.to_s})
        return '' if value.empty?
        related_object_name = humanize_identifiers.select do |humanize_identifier|
          value.respond_to?(humanize_identifier)
        end.first

        if related_object_name.present?
          return value.collect { |related_object| datatable_cell_value(related_object, related_object_name) }.join(', ')
        else
          return value.collect { |related_object| datatable_cell_value(related_object, related_object_name) }.join(', ')
        end
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

      if object.class.defined_enums.has_key?(attr.to_s)
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

      if object.class.columns_hash.keys.include?(attr.to_s) && object.class.columns_hash[attr.to_s].type == :text
        return simple_format(auto_link(value, html: { target: '_blank' }))
      end

      format_value(value)
    end


    end
  end
end


