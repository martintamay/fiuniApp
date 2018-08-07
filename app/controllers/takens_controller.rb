class TakensController < ApplicationController
  before_action :set_taken, only: [:show, :update, :destroy]

  def index
    takens = Taken.all
    render json: takens
  end

  def update
    if @taken.update(taken_params)
      render json: @taken
    else
      render json: @taken.errors, status: :unprocessable_entity
    end
  end

  def create
    @taken = Taken.new(taken_params)

    if @taken.save
      render json: @taken, status: :created, location: @taken
    else
      render json: @taken.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @taken
  end

  def destroy
    @taken.destroy
  end

  private
    def set_taken
      @taken = Taken.find(params[:id])
    end

    def taken_params
      params.require(:taken).permit(:student_id,:subject_id,:inscription_date)
    end
end
