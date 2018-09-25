class SubjectsController < ApplicationController
  before_action :authenticate
  before_action :set_subject, only: [:show, :update, :destroy, :notes, :examinations, :unfinished_notes, :notes_of_year, :set_profesor, :examination_inscriptions]
  before_action :check_access, only: [:update, :notes, :unfinished_notes, :notes_of_year]

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
    if !@user.is_administrator
      return render plain: "unauthorized", status: :unauthorized
    end
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
    if !@user.is_administrator
      return render plain: "unauthorized", status: :unauthorized
    end
    @subject.destroy
  end

  def examination_inscriptions
    conditions = { takens: { subject: @subject } }
    if params.has_key? :uncheckeds
      conditions[:approved] = 3
    end
    if params.has_key? :state
      conditions[:approved] = params[:state]
    end

    @examination_inscriptions = ExaminationInscription.joins(:taken).where(conditions)

    render json: @examination_inscriptions
  end


  def set_profesor
    @subject.professor_id = params.require(:professor_id)
    if @subject.save
      render json: @subject.as_json({
        :only => [:id, :name, :semester, :career_id],
        :methods => [],
        :include => []
      })
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
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

    def check_access
      if !(@user.is_administrator || (@user.is_professor && @subject.is_professor != @user.professor))
        return_unauthorized
      end
    end
end
