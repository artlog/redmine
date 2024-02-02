class AttributeGroup < ActiveRecord::Base
  include Redmine::SafeAttributes
  belongs_to :project
  belongs_to :tracker
  has_many :attribute_group_fields, :dependent => :delete_all
  has_many :custom_fields, :through => :attribute_group_fields
  acts_as_positioned

  validates_length_of :description, :maximum => 1024

  scope :sorted, lambda { order(:position) }

  safe_attributes 'name', 'description', 'position'
end
