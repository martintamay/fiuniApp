class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :update, :destroy, :notes, :subjects]

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

  def logIn
    datos = params.require(:student).permit(:email,:password)
    student = Student.all.take
    user = student.login(datos[:email], datos[:password])
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
    if(@student)
      render json: @student.notes.as_json({
        :only => [:id,:opportunity,:takenDate,:score,:percentage,:noteType],
        include: { taken: { only: [:subject_id]}}
      })
    else
      render json: { "error" => "student not found" }, status: :not_found
    end
  end

  def subjects
    if(@student)
      render json: @student.subjects
    end
  end

  private
    def set_student
      if params[:id]
        @movement = Student.find(params[:id])
      else
        @movement = Student.find(params[:student_id])
      end
    end

    def student_params
      params.require(:student).permit(:person_id,:entry_year,:career_id)
    end
end
