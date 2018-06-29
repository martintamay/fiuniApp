class ProfessorsController < ApplicationController
  def index
    professors = Professor.all
    respond_to do |format|
      format.json { render json: professors }
    end
  end

  def update
    professor = Professor.find_by_id(params[:id])
    if(professor)
      professor.update(professor_params)
      redirect_to professor_path(professor, format: :json)
    end
  end

  def create
    professor = Professor.new(professor_params)
    professor.save
    redirect_to professor_path(professor, format: :json)
  end

  def show
    professor = Professor.find_by_id(params[:id])
    if(professor)
      respond_to do |format|
        format.json { render json: professor }
      end
    end
  end

  def destroy
    professor = Professor.find_by_id(params[:id])
    if(professor)
      professor.destroy
      render json: {}, status: :no_content
    end
  end

  private
    def professor_params
      params.require(:professor).permit(:person_id)
    end
end
