#encoding: UTF-8
module CustomFieldsHelperPatch
  def self.included(base)
    base.class_eval do
      prepend AttributeCategoriesHelper
    end
  end
end
