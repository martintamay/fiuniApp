class CareerController < ApplicationController
  before_action :authenticate
  before_action :set_career, only: [:show, :update, :destroy, :subjects, :students]
  before_action :check_access, only: [:update, :destroy, :create]

  def index
    render json: Career.all
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

  def students
    render json: @career.students
  end

  def subjects
    render json: @career.subjects
  end

  private
    def set_career
      if params[:id]
        @career = Career.find(params[:id])
      else
        @career = Career.find(params[:career_id])
      end
    end

    def career_params
      params.require(:career).permit(:description)
    end

    def check_access
      if(!@user.is_administrator)
        return_unauthorized
      end
    end
end
