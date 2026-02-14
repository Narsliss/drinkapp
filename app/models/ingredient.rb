class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  belongs_to :category, class_name: 'IngredientCategory', optional: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
