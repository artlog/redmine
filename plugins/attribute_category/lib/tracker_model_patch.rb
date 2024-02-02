#encoding: UTF-8
module TrackerModelPatch
  def self.included(base)
    base.class_eval do
      # Custom field for the project issues
      has_many :attribute_groups, :dependent => :destroy
      has_many :attribute_group_fields, :through => :attribute_groups
    end
  end
end
