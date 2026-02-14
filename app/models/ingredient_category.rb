class IngredientCategory < ApplicationRecord
  has_many :ingredients, foreign_key: 'category_id'

  validates :name, presence: true, uniqueness: true
end
