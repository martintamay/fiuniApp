class ExaminationInscriptionsController < ApplicationController
  before_action :set_examination_inscription, only: [:show, :update, :destroy]
  def index
    examination_inscriptions = ExaminationInscription.all
    render json: examination_inscriptions
  end

  def show
    render json: @examination_inscription
  end

  def create
    @examination_inscription= ExaminationInscription.new(examination_inscription_params)

    if @examination_inscription.save
      render json: @examination_inscription, status: :created, location: @examination_inscription
    else
      render json: @examination_inscription.errors, status: :unprocessable_entity
    end
  end

  def update
    if @examination_inscription.update(examination_inscription_params)
      render json: @examination_inscription
    else
      render json: @examination_inscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @examination_inscription.destroy
  end

  def uncheckeds
    @examination_inscriptions = ExaminationInscription.where( approved: 3 )
    render json: @examination_inscriptions
  end

  private
    def set_examination_inscription
      if params[:id]
        @examination_inscription= ExaminationInscription.find(params[:id])
      else
        @examination_inscription= ExaminationInscription.find(params[:examination_id])
      end
    end

    def examination_inscription_params
      params.require(:examination_inscription).permit(:inscription_date,:taken_id,:examination_id)
    end
end
