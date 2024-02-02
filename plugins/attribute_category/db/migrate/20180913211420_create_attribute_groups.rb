class CreateAttributeGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :attribute_groups do |t|
      t.references :project, index: true, foreign_key: true
      t.references :tracker, index: true, foreign_key: true
      t.string :name
      t.integer :position, :default => nil, :null => true

      t.timestamps null: false
    end
  end
end
