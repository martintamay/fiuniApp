class CareerController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @careers = Career.all
    respond_to do |format|
      format.json { render json: @careers }
    end
  end

  def update
    career = Career.find(params[:id])
    career.update(career_params)
    redirect_to career_path(career, format: :json)
  end

  def create
    career = Career.new(career_params)
    career.save
    redirect_to career_path(career, format: :json)
  end

  def show
    @career = Career.find(params[:id])
    respond_to do |format|
      format.json { render json: @career }
    end
  end

  def destroy
    career = Career.find(params[:id])
    career.destroy
    render json: {}, status: :no_content
  end

  private
    def career_params
      params.require(:career).permit(:description)
    end
end
