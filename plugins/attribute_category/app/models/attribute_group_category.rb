class AttributeGroupCategory

  def initialize(attribute_group, attribute_category)
    @attribute_category=attribute_category
    @attribute_group=attribute_group
  end

  def name
    @attribute_category.nil? ? nil : @attribute_category.name
  end

  def description
    @attribute_category.nil? ? nil : @attribute_category.description
  end

  def full_width_layout
    @attribute_group.respond_to?(:full_width_layout) ? @attribute_group.full_width_layout : :false;
  end

  def to_s
    ' ' + @attribute_group.to_s
    ' ' + @attribute_category.to_s
  end

end
