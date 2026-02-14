class CreateIngredientCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredient_categories do |t|
      t.string :name, null: false
      t.timestamps
    end
    
    add_index :ingredient_categories, :name, unique: true
    
    # Add category_id to ingredients
    add_column :ingredients, :category_id, :integer
    add_index :ingredients, :category_id
  end
end
