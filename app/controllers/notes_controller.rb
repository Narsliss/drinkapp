class NotesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @note = @recipe.build_note(note_params)

    if @note.save
      redirect_to @recipe, notice: 'Note added!'
    else
      redirect_to @recipe, alert: 'Failed to add note.'
    end
  end

  def update
    @recipe = Recipe.find(params[:recipe_id])
    @note = @recipe.note

    if @note.update(note_params)
      redirect_to @recipe, notice: 'Note updated!'
    else
      redirect_to @recipe, alert: 'Failed to update note.'
    end
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
