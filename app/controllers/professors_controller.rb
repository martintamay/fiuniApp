class ProfessorsController < ApplicationController
  before_action :authenticate
  before_action :set_professor, only: [:show, :update, :destroy, :subjects]
  before_action :check_access, only: [:index, :create, :destroy]
  before_action :check_access_or_owner, only: [:update, :subjects]

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
      logger.info(JSON.generate(params[:professor][:person]))
      person_data = params[:professor][:person].permit(:ci,:email,:names,:password)
      person = Person.new(person_data)
      person.save!
      @professor.person = person
      @professor.save!
      render json: @professor, status: :created, location: @professor
    end
  rescue ActiveRecord::StatementInvalid
    render json: @professor.errors , status: :unprocessable_entity
  end

  def subjects
    subjects = @professor.subjects
    render json: subjects.as_json({
        only: [:id,:name,:semester,:career_id],
        include: []
    })
  end

  def show
    render json: @professor
  end

  def destroy
    @professor.destroy
  end

  private
    def set_professor
      if params[:id]
        @professor = Professor.find(params[:id])
      else
        @professor = Professor.find(params[:professor_id])
      end
    end

    def professor_params
      params.require(:professor)
    end

    def check_access
      if !@user.is_administrator
        return_unauthorized
      end
    end

    def check_access_or_owner
      if !(@user.is_administrator || (@user.is_professor && @professor != @user.is_professor))
        return_unauthorized
      end
    end
end
