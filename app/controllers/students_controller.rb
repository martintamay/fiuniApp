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

    Student.transaction do
      #se crea la persona de ser necesaria, si no se la busca
      if params[:student][:person]
        @student.person = Person.create(params.require(:student).require(:person).permit(:names,:email,:password,:ci))
      else
        @student.person_id = params.require(:student)[:person_id]
      end
      #se guarda el estudiante
      @student.save!
      #se devuelve el estudiante creado
      render json: @student, status: :created, location: @student
    end
  rescue ActiveRecord::StatementInvalid
    render json: @student.errors, status: :unprocessable_entity
  end

  def show
    render json: @student
  end
  def notesFrom
    student= Student.find_by_id(params[:id])
    if(student)
      fechaBuscar=params[:init_date]
      render json: student.notesFrom(fechaBuscar)
    end
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
      render json: user.as_json(:only => [:id,:entry_year,:android_session_token], \
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
      params.require(:student).permit(:entry_year,:career_id)
    end
end
