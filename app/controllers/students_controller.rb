class StudentsController < ApplicationController
  def index
    students = Student.all
    render json: students 
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
    student = Student.find_by_id(params[:student_id])
    if(student)
      render json: student.notes.as_json({
        :only => [:id,:opportunity,:takenDate,:score,:percentage,:noteType],
        include: { taken: { only: [:subject_id]}}
      })
    else
      render json: { "error" => "student not found" }, status: :not_found
    end
  end

  def update
    student = Student.find_by_id(params[:id])
    if(student)
      student.update(student_params)
      redirect_to student_path(student, format: :json)
    end
  end

  def create
    student = Student.new(student_params)
    student.save
    redirect_to student_path(student, format: :json)
  end

  def show
    student = Student.find_by_id(params[:id])
    if(student)
      respond_to do |format|
        format.json { render json: student }
      end
    end
  end

  def destroy
    student = Student.find_by_id(params[:id])
    if(student)
      student.destroy
      render json: {}, status: :no_content
    end
  end

  private
    def student_params
      params.require(:student).permit(:person_id,:entry_year,:career_id)
    end
end
