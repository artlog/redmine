class AddCustomFieldsGroupCategoryLayout < ActiveRecord::Migration[4.2]
  def up
    add_column :custom_fields, :group_category_layout, :text
  end

  def down
    remove_column :custom_fields, :group_category_layout
  end
end
