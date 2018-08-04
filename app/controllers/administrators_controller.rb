class AdministratorsController < ApplicationController
  before_action :set_administrator, only: [:show, :update, :destroy]

  def index
    administradors = Administrator.all
    render json: administradors
  end

  def create
    @administrador = Administrator.new(administrator_params)
    if @administrador.save
      render json:@administrador, status: :created, location: @administrador
    else
      render json:@administrador.errors, status: :unprocessable_entity
    end
  end

  def update
    if(@administrador.update(administrator_params))
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
      params.require(:administrator).permit(:person_id)
    end
end
