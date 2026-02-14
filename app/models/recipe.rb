class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :ratings, dependent: :destroy
  has_one :note, dependent: :destroy

  validates :name, presence: true
  validates :instructions, presence: true

  scope :with_ingredients, lambda { |ingredient_ids|
    joins(:ingredients)
      .where(ingredients: { id: ingredient_ids })
      .group('recipes.id')
      .having('COUNT(DISTINCT ingredients.id) = ?', ingredient_ids.length)
  }

  def average_rating
    ratings.average(:score)&.round(1) || 0
  end
end
