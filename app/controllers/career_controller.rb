class CareerController < ApplicationController
  def index
    careers = Career.all
    render json: careers
  end

  def update
    career = Career.find_by_id(params[:id])
    if(career)
      career.update(career_params)
      redirect_to career_path(career, format: :json)
    end
  end

  def create
    career = Career.new(career_params)
    career.save
    redirect_to career_path(career, format: :json)
  end

  def show
    career = Career.find_by_id(params[:id])
    if(career)
      respond_to do |format|
        format.json { render json: career }
      end
    end
  end

  def destroy
    career = Career.find_by_id(params[:id])
    if(career)
      career.destroy
      render json: {}, status: :no_content
    end
  end

  private
    def career_params
      params.require(:career).permit(:description)
    end
end
