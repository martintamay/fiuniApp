class NotesController < ApplicationController
  def index
    notas = Note.all
    render json: notas
  end

  def update
    nota = Note.find_by_id(params[:id])
    if(nota)
      nota.update(nota_params)
      redirect_to nota_path(nota, format: :json)
    end
  end

  def create
    nota = Note.new(nota_params)
    nota.save
    redirect_to nota_path(nota, format: :json)
  end

  def show
    nota = Note.find_by_id(params[:id])
    if(nota)
      respond_to do |format|
        format.json { render json: notal }
      end
    end
  end

  def destroy
    nota = Note.find_by_id(params[:id])
    if(nota)
      nota.destroy
      render json: {}, status: :no_content
    end
  end

  def bulkCheck
    #todo: check the notes in the list
  end

  private
    def nota_params
      params.require(:nota).permit(:description)
    end
end
