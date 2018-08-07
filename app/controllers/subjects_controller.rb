class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :update, :destroy, :notes, :examinations, :unfinished_notes, :notes_of_year]

  def index
    subjects = Subject.all
    render json: subjects
  end

  def update
    if @subject.update(subject_params)
      render json: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      render json: @subject, status: :created, location: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @subject
  end

  def destroy
    @subject.destroy
  end

  def examinations
    render json: @subject.examinations
  end

  def notes
    if(@subject)
      render json: @subject.notes
    else
      render json: {}, status: :not_found
    end
  end

  def unfinished_notes
    year = params[:year]
    if(@subject)
      render json: @subject.notes_from_year(year)
    else
      render json: {}, status: :not_found
    end
  end

  def notes_of_year
    year = params[:year]
    if(@subject)
      render json: @subject.notes_from_year(year)
    else
      render json: [], status: :not_found
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
      params.require(:subject).permit(:name,:semester,:career_id)
    end
end
