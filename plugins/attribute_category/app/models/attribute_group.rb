class AttributeGroup < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project
  belongs_to :tracker
  has_many :attribute_group_fields, :dependent => :delete_all
  has_many :custom_fields, :through => :attribute_group_fields
  acts_as_positioned

  scope :sorted, lambda { order(:position) }

  safe_attributes 'name', 'position', 'full_width_layout'

  def full_width_layout?
    ActiveRecord::Type::Boolean.new.cast(full_width_layout)
  end

end
