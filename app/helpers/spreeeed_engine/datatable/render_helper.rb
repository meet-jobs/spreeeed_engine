module SpreeeedEngine
  module Datatable
    module RenderHelper

      def render_sortable_cols(klass, attrs)
        sortable_cols = []
        if klass.datatable_sortable_cols.kind_of?(ActiveSupport::OrderedHash)
          sortable_cols = klass.sortable_cols.collect { |label, _attrs| _attrs }.flatten
        elsif klass.datatable_sortable_cols.kind_of?(Array)
          sortable_cols = klass.datatable_sortable_cols
        end
        # Rails.logger.debug("**** sortable_cols = #{sortable_cols.inspect}")

        res = attrs.collect { |attr|
          {bSortable: sortable_cols.include?(attr)}
        }
        # Rails.logger.debug("**** datatable sort options = #{res}")
        res
      end

      def render_default_sortable_cols(sortable_cols, cols)
        res = []
        sortable_cols.each do |sortable_col|
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
        t('search') + ' ' + searchable_cols.collect do |col|
          klass.human_attribute_name(col.to_sym)
        end.join(', ')
      end

    end
  end
end


