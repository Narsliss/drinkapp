class RatingsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @rating = @recipe.ratings.build(rating_params)

    if @rating.save
      redirect_to @recipe, notice: 'Rating added!'
    else
      redirect_to @recipe, alert: 'Failed to add rating.'
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:score)
  end
end
