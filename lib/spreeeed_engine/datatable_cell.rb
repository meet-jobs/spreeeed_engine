class DatatableCell
  attr_accessor :label, :attr, :value

  def initialize(object, attr_name)
    @label = object.class.human_attribute_name(attr_name.to_sym)
    @attr  = attr_name
  end

end