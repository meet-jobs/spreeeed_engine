module ActiveRecordExtension
  extend ActiveSupport::Concern


  class_methods do
    def icon
      'fas fa-edit'
    end

    def protected_attrs
      %w(id created_at updated_at).map(&:to_sym)
    end

    def displayable_attrs
      self.new.attributes.keys.map(&:to_sym) - protected_attrs
    end

    def editable_attrs
      displayable_attrs - protected_attrs
    end

    def hidden_attrs
      []
    end

    def nested_attrs
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