class ProfessorsController < ApplicationController
  before_action :set_professor, only: [:show, :update, :destroy]

  def index
    professors = Professor.all
    render json: professors
  end

  def update
    @person = @professor.person
    person_params = professor_params[:person].permit(:names,:ci,:email,:password)
    if @person.update(person_params)
      render json: @professor
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def create
    @professor = Professor.new
    Professor.transaction do
      begin
        logger.info(JSON.generate(params[:professor][:person]))
        person_data = params[:professor][:person].permit(:ci,:email,:names,:password)
        person = Person.new(person_data)
        person.save!
        @professor.person = person
        @professor.save!
        render json: @professor, status: :created, location: @professor
      rescue ActiveRecord::StatementInvalid
        render json: @professor.errors , status: :unprocessable_entity
      end
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
      params.require(:professor)
    end
end
