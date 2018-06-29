class PeopleController < ApplicationController
  def index
    people = Person.all
    respond_to do |format|
      format.json { render json: people }
    end
  end

  def update
    person = Person.find_by_id(params[:id])
    if(person)
      person.update(person_params)
      redirect_to person_path(person, format: :json)
    end
  end

  def create
    person = Person.new(person_params)
    person.save
    redirect_to person_path(person, format: :json)
  end

  def show
    person = Person.find_by_id(params[:id])
    if(person)
      respond_to do |format|
        format.json { render json: person }
      end
    end
  end

  def destroy
    person = Person.find_by_id(params[:id])
    if(person)
      person.destroy
      render json: {}, status: :no_content
    end
  end

  private
    def person_params
      params.require(:person).permit(:names, :email, :password, :ci)
    end
end
