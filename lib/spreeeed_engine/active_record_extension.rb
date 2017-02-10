module ActiveRecordExtension
  extend ActiveSupport::Concern


  class_methods do
    def icon
      'fa-edit'
    end

    def protected_cols
      %w(id created_at updated_at).map(&:to_sym)
    end

    def displayable_cols
      self.new.attributes.keys.map(&:to_sym) - protected_cols
    end

    def editable_cols
      displayable_cols - protected_cols
    end

    def hidden_cols
      []
    end

    def nested_cols
      res = ActiveSupport::OrderedHash.new

      cols = self.nested_attributes_options.keys.compact
      cols.each do |col|
        self.reflect_on_all_associations.each do |r|
          name = r.name.to_s
          col_name = col.to_s.gsub('_attributes', '')
          if name == col_name
            res[name] = (r.options[:class_name] ? r.options[:class_name] : col_name.to_s.singularize.camelize)
          end
        end
      end

      res
    end

    def all_associations(macro=nil)
      self.reflect_on_all_associations(macro)
    end

    def all_associations_names(macro=nil)
      all_associations(macro).collect(&:name)
    end

    def all_associations_ids(macro=nil)
      res = []
      all_associations(macro).each do |association|
        if association.options and association.options[:foreign_key]
          res << association.options[:foreign_key]
        else
          res << association.name.to_s.foreign_key.to_sym
        end
      end
      res
    end

    def attrs_input_mapping
      {}
    end

    def attrs_display_mapping
      {}
    end

  end

end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)