class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :update, :destroy, :notes]

  def index
    subjects = Subject.all
<<<<<<< HEAD
    respond_to do |format|
      format.json { render json: subjects }
    end
  end

  def update
    subject = Subject.find_by_id(params[:id])
    if(subject)
      subject.update(subject_params)
      redirect_to subject_path(subject, format: :json)
=======
    render json: subjects
  end

  def update
    if @subject.update(subject_params)
      render json: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
>>>>>>> b57fa50226e1cb4797e8e4a773e45e1e96ff79b2
    end
  end

  def create
<<<<<<< HEAD
    subject = Subject.new(subject_params)
    subject.save
    redirect_to subject_path(subject, format: :json)
=======
    @subject = Subject.new(subject_params)

    if @subject.save
      render json: @subject, status: :created, location: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
>>>>>>> b57fa50226e1cb4797e8e4a773e45e1e96ff79b2
  end

  def show
    render json: @subject
  end

  def destroy
    @subject.destroy
  end

  def notes
    if(@subject)
      render json: @subject.notes
    else
      render json: {}, status: :not_found
    end
  end

  private
    def set_subject
      if params[:id]
        @subject = Subject.find(params[:id])
      else
        @subject = Subject.find(params[:subject_id])
      end
    end

    def subject_params
<<<<<<< HEAD
      params.require(:subject).permit(:name,:semester,:professor_id)
=======
      params.require(:subject).permit(:name, :semester, :career_id)
>>>>>>> b57fa50226e1cb4797e8e4a773e45e1e96ff79b2
    end
end
