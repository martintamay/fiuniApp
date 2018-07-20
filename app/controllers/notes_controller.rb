class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :destroy]

  def index
    notas = Note.all
    render json: notas
  end

  def update
    if @nota.update(nota_params)
      render json: @nota
    else
      render json: @nota.errors, status: :unprocessable_entity
    end
  end

  def create
    @nota = Note.new(nota_params)

    if @nota.save
      render json: @nota, status: :created, location: @nota
    else
      render json: @nota.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @nota
  end

  def destroy
    @nota.destroy
  end

  def bulkCheck
    #todo: check the notes in the list
  end

  private
    def set_note
       @nota = Note.find(params[:id])
    end

    def nota_params
      params.require(:nota).permit(:description)
    end
end
