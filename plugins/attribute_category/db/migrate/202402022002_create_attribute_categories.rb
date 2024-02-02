class CreateAttributeCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :attribute_categories do |t|
      t.string :name
      t.string :description
    end
  end
end
