class AddFullWidthLayout < ActiveRecord::Migration[6.1]
  def up
    add_column :attribute_groups, :full_width_layout, :boolean, :default => false
  end

  def down
    remove_column :attribute_groups, :full_width_layout
  end
end
