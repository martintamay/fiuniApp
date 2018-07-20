class SubjectsController < ApplicationController
  def index
    subjects = Subject.all
    render json: subjects
  end

  def update
    subjetc = Subject.find_by_id(params[:id])
    if(subject)
      subject.update(subject_params)
      redirect_to subject_path(subject, format: :json)
    end
  end

  def create
    subject = Subject.new(subject_params)
    subject.save
    redirect_to subject_path(subject, format: :json)
  end

  def show
    subject = Subject.find_by_id(params[:id])
    if(subject)
      respond_to do |format|
        format.json { render json: subject }
      end
    end
  end

  def destroy
    subject = Subject.find_by_id(params[:id])
    if(subject)
      subject.destroy
      render json: {}, status: :no_content
    end
  end

  def notes
    subject = Subject.find_by_id(params[:subject_id])
    if(subject)
      render json: subject.notes
    else
      render json: {}, status: :not_found
    end
  end

  private
    def subject_params
      params.require(:subject).permit(:name, :semester, :professor_id)
    end
end
