class ProfessorsController < ApplicationController
  before_action :set_professor, only: [:show, :update, :destroy]

  def index
    professors = Professor.all
    render json: professors
  end

  def update
    if @professor.update(professor_params)
      render json: @professor
    else
      render json: @professor.errors, status: :unprocessable_entity
    end
  end

  def create
    @professor = Professor.new(professor_params)

    if @professor.save
      render json: @professor, status: :created, location: @professor
    else
      render json: @professor.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @professor
  end

  def destroy
    @professor.destroy
  end

  private
    def set_professor
      @professor = Professor.find(params[:id])
    end

    def professor_params
      params.require(:professor).permit(:person_id)
    end
end
