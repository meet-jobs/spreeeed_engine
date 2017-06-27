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

    end
  end
end


