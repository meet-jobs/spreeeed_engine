module SpreeeedEngine
  module UtilityHelper

    def pluralize?(name)
      !(name.pluralize == name && name.singularize == name)
    end

  end
end
