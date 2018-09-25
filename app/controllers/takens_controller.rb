class TakensController < ApplicationController
  before_action :authenticate
  before_action :set_taken, only: [:show, :update, :destroy]
  before_action :check_access, only: [:index, :update, :destroy]
  before_action :check_access_or_owner, only: [:show, :create]

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
  def bulk_inscription
    Taken.transaction do
      student_id= params.require(:student_id)
      subjects_id= params.require(:subjects_id)
      subjects_id.each do |id|
        Taken.create([{
          inscription_date: DateTime.now,
          finished:0,
          finish_date: nil,
          student_id: student_id,
          subject_id:id }])
      end
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

    def check_access
      if !@user.is_administrator
        return_unauthorized
      end
    end

    def check_access_or_owner
      if !(@user.is_administrator || (@user.is_student && @taken.is_student == @user.student))
        return_unauthorized
      end
    end
end
