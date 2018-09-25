class NotesController < ApplicationController
  before_action :authenticate
  before_action :set_note, only: [:show, :update, :destroy]
  before_action :check_access, only: [:index, :update, :create, :destroy, :bulkCheck, :bulkInsert]
  before_action :check_access_or_owner, only: [:show]

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
    updatedNotes = []
    Note.transaction do
      params.require(:notes).each do |note|
        datos = note.permit(:id,:checked)
        @nota = Note.find(datos[:id])
        #se setea el checked
        @nota.checked = datos[:checked]
        #se guarda
        @nota.save!
        updatedNotes.push @nota
      end
    end
    render json: updatedNotes
  end

  def bulkInsert
    insertedNotes = []
    Note.transaction do
      params.require(:notes).each do |note|
        @nota = Note.new(note.permit(:score,:approved,:percentage,:taken_id))
        @nota.save!
        insertedNotes.push @nota
      end
    end
    render json: insertedNotes
  end

  private
    def set_note
       @nota = Note.find(params[:id])
    end

    def nota_params
      params.require(:note).permit(:score,:approved,:percentage,:taken_id)
    end

    def check_access
      if !(@user.is_administrator || (@user.is_professor && @note.examination.subject.professor != @user.is_professor))
        return_unauthorized
      end
    end

    def check_access_or_owner
      if !(@user.is_administrator || (@user.is_professor && @note.examination.subject.professor != @user.is_professor))
        if !(@user.is_student && @note.taken.student == @user.is_student)
          return_unauthorized
        end
      end
    end
end
