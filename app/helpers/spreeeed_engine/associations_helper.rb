module SpreeeedEngine
  module AssociationsHelper

    def all_associations(klass, relationship, association={})
      %w(name class_name foreign_key).each do |key|
        if association[key.to_sym].present?
          klass.all_associations(relationship.to_sym).each do |relationship|
            return relationship if relationship.send(key.to_sym).to_s == association[key.to_sym].to_s
          end
        end
      end

      nil
    end

    %w(has_one has_many belongs_to).each do |relationship|
      define_method("#{relationship}_association".to_sym) do |klass, association={}|
        all_associations(klass, relationship.to_sym, association)
      end

      define_method("#{relationship}_association?".to_sym) do |klass, association={}|
        !all_associations(klass, relationship.to_sym, association).nil?
      end
    end


  end
end
