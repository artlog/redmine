class AddAttributeGroupsDescription < ActiveRecord::Migration[6.1]
  def up
    add_column :attribute_groups, :description, :string, :after => :name
  end

  def down
    remove_column :attribute_groups, :description
  end
end
