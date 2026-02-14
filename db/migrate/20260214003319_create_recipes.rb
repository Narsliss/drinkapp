class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.text :instructions
      t.string :image_url
      t.string :source_url
      t.string :glass

      t.timestamps
    end
  end
end
