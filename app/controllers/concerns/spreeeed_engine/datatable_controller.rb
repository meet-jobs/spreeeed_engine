module SpreeeedEngine
  module DatatableController
    extend ActiveSupport::Concern

    include SpreeeedEngine::AttributeHelper

    def datatable_cells(object, attrs)
      attrs.collect do |attr|
        cell = DatatableCell.new(object, attr)
        cell.value = view_context.datatable_cell_value(object, attr)
        cell
      end
    end

    def datatable_labels(object, attrs)
      datatable_cells(object, attrs).collect{ |col| col.label }
    end

    def datatable_sortable_columns(klass, datatable_columns, default_sortable_cols)
      sort_cols        = []
      if params[:iSortCol_0].present?
        sort_col         = datatable_columns[params[:iSortCol_0].to_i] || 'id'

        associations = {}
        klass.all_associations(:belongs_to).each { |relationship| associations[relationship.name] = relationship.foreign_key }
        if associations.keys.include?(sort_col)
          sort_col = associations[sort_col]
        end

        sort_by          = params[:sSortDir_0] ? params[:sSortDir_0] : 'ASC'
        sort_cols        << [sort_col, sort_by]
      else
        sort_cols        = default_sortable_cols
      end
      sort_cols
    end

    def datatable_instances_proxy(klass, searchable_columns, sortable_columns)
      _proxy = if params[:sSearch].present?
                 q = params[:sSearch]
                 klass.where(searchable_conditions(searchable_columns, q))
               else
                 klass
               end
      _proxy.order(order_conditions(sortable_columns))
    end

    def datatable_instances(proxy, page, per_page)
      proxy.paginate(:page => page, :per_page => per_page)
    end

    def datatable_instances_total(proxy)
      proxy.count
    end

    def datatable_raws(objects, attrs, total)
      # aoColumns = []
      aaData = objects.collect{ |object|
        datatable_cells(object, attrs).collect do |col|
          col.value
        end
        # aoColumns = datatable_col_defs(object, attrs) if aoColumns.empty?
      }

      {
        sEcho:                params[:sEcho],
        iTotalRecords:        total,
        iTotalDisplayRecords: total,
        aaData:               aaData,
        # "aoColumns"            => aoColumns,
      }
    end





    def searchable_conditions(searchable_cols, q)
      res        = []
      conditions = []
      searchable_cols.each do |col|
        conditions << "#{col} ILIKE ?"
        res << "%#{q}%"
      end
      [conditions.join(' OR ')] + res
    end

    def order_conditions(sort_cols)
      sort_cols.collect{ |sort_col| "#{sort_col[0]} #{sort_col[1]}"}.join(', ')
    end


  end
end
