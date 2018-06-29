class StudentsController < ApplicationController
  def index
    students = Student.all
    respond_to do |format|
      format.json { render json: students }
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
