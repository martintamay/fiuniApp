class ExaminationsController < ApplicationController
  def index
    examinations = Examination.all
    render json: examinations
  end

  def show
    render json: @examination
  end

  def create
    @examination = Examination.new(examination_params)

    if @examination.save
      render json: @examination, status: :created, location: @examination
    else
      render json: @examination.errors, status: :unprocessable_entity
    end
  end

  def update
    if @examination.update(examination_params)
      render json: @examination
    else
      render json: @examination.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @examination.destroy
  end


  def uncheckeds
    @examinations = Examination.joins(:notes).where(notes: { checked: 0 })
    render json: @examinations
  end

  private
    def set_examination
      if params[:id]
        @examination = Examination.find(params[:id])
      else
        @examination = Examination.find(params[:examination_id])
      end
    end

    def examination_params
      params.require(:examination).permit(:examination_date,:examination_type,:subject_id)
    end
end
