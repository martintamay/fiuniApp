class AdministratorsController < ApplicationController
  before_action :authenticate
  before_action :set_administrator, only: [:show, :update, :destroy]
  before_action :check_access

  def index
    administradors = Administrator.all
    render json: administradors
  end

  def create
    @administrador = Administrator.new
    Professor.transaction do
      person_data = params[:administrator][:person].permit(:ci,:email,:names,:password)
      person = Person.new(person_data)
      person.save!
      @administrador.person = person
      @administrador.save!
      render json: @administrador, status: :created, location: @administrador
    end
  rescue ActiveRecord::StatementInvalid
    render json: @administrador.errors , status: :unprocessable_entity
  end

  def update
    @person = @administrador.person
    person_params = professor_params[:person].permit(:names,:ci,:email,:password)
    if @person.update(person_params)
      render json: @administrador
    else
      render json: @administrador.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @administrador
  end

  def destroy
    @administrador.destroy
  end

  private
    def set_administrator
      @administrador = Administrator.find(params[:id])
    end

    def administrator_params
      params.require(:administrator)
    end

    def check_access
      if(!@user.is_administrator)
        return_unauthorized
      end
    end
end
