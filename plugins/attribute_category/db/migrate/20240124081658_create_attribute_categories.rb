class CreateAttributeCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :attribute_categories do |t|
      t.string :name
      t.string :description
    end
  end
end
