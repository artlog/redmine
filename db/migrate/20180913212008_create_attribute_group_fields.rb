class CreateAttributeGroupFields < ActiveRecord::Migration[4.2]
  def change
    create_table :attribute_group_fields do |t|
      t.references :attribute_group, index: true, foreign_key: true
      t.references :custom_field, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
