#encoding: UTF-8
module CustomFieldModelPatch
  def self.included(base)
    base.class_eval do
      has_many :attribute_group_fields, :dependent => :delete_all
    end
  end
end
