class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :update, :destroy, :notes, :subjects, :lastNotes]

  def index
    students = Student.all
    render json: students
  end

  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      render json: @student, status: :created, location: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @student
  end

  def destroy
    @student.destroy
  end

  def subjects
    render json: @student.subjects
  end

  def lastNotes
    lastDate = params[:last_date]
    lastDate += " "+params[:last_time].gsub('-', ':')

    takens = @student.takens
    @notes = []
    takens.each do |taken|
      @notes.concat(taken.notes.where("checked = 1 AND updated_at >= :last_date", :last_date => lastDate))
    end

    render json: @notes
  end

  def logIn
    datos = params.require(:student).permit(:email,:password)
    user = Student.login(datos[:email], datos[:password])
    if user
      render json: user.as_json(:only => [:id,:entry_year], \
        include: {
          person: { :only => [:email,:ci,:names,:session_token] },
          career: { :only => [:id,:description] }
        })
    else
      render json: { "error" => "incorrect user" }, status: :unauthorized
    end
  end

  def notes
    render json: @student.notes.as_json({
      :only => [:id,:opportunity,:takenDate,:score,:percentage,:noteType],
      include: { taken: { only: [:subject_id]}}
    })
  end

  private
    def set_student
      if params[:id]
        @student = Student.find(params[:id])
      else
        @student = Student.find(params[:student_id])
      end
    end

    def student_params
      params.require(:student).permit(:person_id,:entry_year,:career_id)
    end
end
