class StudentsController < ApplicationController
  before_action :authenticate, except: [:logIn, :create]
  before_action :set_student, only: [:show, :update, :destroy, :notes, :subjects, :lastNotes, :available_examinations, :examination_inscriptions]
  before_action :check_access, only: [:show]
  before_action :check_admin, only: [:destroy,:index]
  before_action :check_access_or_owner, only: [:update,:notesFrom,:subjects,:lastNotes,:notes]

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

  def destroy
    @student.destroy
  end


  def available_examinations
    student_id = @student.id
    # se obtienen las materias que el alumno está cursando actualmente
    subjects = Subject.joins(:takens).where(takens: { finished: 0, student_id: student_id }).pluck(:id)
    # se obtiene los examenes a los que ya se inscribió
    inscribed = ExaminationInscription.joins(:taken).where(takens: { student_id: student_id }).pluck(:examination_id)
    # se obtienen los exámenes a los que se puede inscribir
    examinations = Examination.where("examination_date > ?", 2.day.from_now.to_date).where.not( id: inscribed ).where(subject_id: subjects)
    #se devuelven los exámenes
    render_format = {
      only: [:id, :examination_type, :examination_date],
      include: [
        subject: {
          only: [:id], include: [], methods: []
        }
      ]
    }
    render json: examinations.as_json(render_format)
  end

  def examination_inscriptions
    takens = Taken.where( student: @student ).pluck( :id )

  #TODO: Corregir select para que traiga los examination inscriptions con notas
    exa_with_notes = Taken.joins( examination_inscriptions: [ :note ] ).
      where( student_id: @student.id).
      pluck( :examination_inscription_id )
    examination_inscriptions = ExaminationInscription.where( taken_id: takens ).
      where.not( id: exa_with_notes )
    render_format = {
      only: [:id, :approved, :inscription_date],
      include: [
        examination: {
          only: [:id, :examination_date, :examination_type],
          include: [ subject: {
              only: [:id]
            }
          ]
        },
        taken: { only: [:id,:student_id]}
      ]
    }
    render json: examination_inscriptions.as_json( render_format )
  end

  def notesFrom
    student= Student.find_by_id(params[:id])
    if(student)
      fechaBuscar=params[:init_date]
      render json: student.notesFrom(fechaBuscar)
    end
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
    render json: Note.joins( :taken ).where( takens: { student: @student } ).as_json({
      only: [:id,:opportunity,:approved,:score,:percentage],
      include: [ taken: { only: [:inscription_date]}],
      methods: []
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

    def check_access
      if !(@user.is_administrator || (@user.is_student == @student) || @user.is_professor)
        return_unauthorized
      end
    end

    def check_admin
      if !@user.is_administrator
        return_unauthorized
      end
    end

    def check_access_or_owner
      if !(@user.is_administrator || (@user.is_student && @user.is_student == @student))
       return_unauthorized
     end
   end
end
