class CareerController < ApplicationController
  before_action :set_career, only: [:show, :update, :destroy]

  def index
    careers = Career.all
    render json: careers
  end

  def update
    if(@career.update(career_params))
      render json: @career
    else
      render json: @career.errors, status: :unprocessable_entity
    end
  end

  def create
    @career = Career.new(career_params)

    if @career.save
      render json: @career, status: :created, location: @career
    else
      render json: @career.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @career
  end

  def destroy
    @career.destroy
  end

  private
    def set_career
      @career = Career.find(params[:id])
    end

    def career_params
      params.require(:career).permit(:description)
    end
end
