class AdministratorsController < ApplicationController
  def index
    administradors = Administrator.all
    render json: administradors
  end

  def update
    administrador = Administrator.find_by_id(params[:id])
    if(administrador)
      administrador.update(administrator_params)
      redirect_to administrator_path(administrador, format: :json)
    end
  end

  def create
    administrador = Administrator.new(administrator_params)
    administrador.save
    redirect_to administrator_path(administrador, format: :json)
  end

  def show
    administrador = Administrator.find_by_id(params[:id])
    if(administrador)
      respond_to do |format|
        format.json { render json: administrador }
      end
    end
  end

  def destroy
    administrador = Administrator.find_by_id(params[:id])
    if(administrador)
      administrador.destroy
      render json: {}, status: :no_content
    end
  end

  private
    def administrator_params
      params.require(:administrator).permit(:person_id)
    end
end
