class PeopleController < ApplicationController
  def index
    people = Person.all
    render json: people
  end

  def update
    person = Person.find_by_id(params[:id])
    if(person)
      person.update(person_params)
      redirect_to person_path(person, format: :json)
    end
  end

  def logIn
      datos = params.require(:person).permit(:email,:password)
      person = Person.all.take
      person = person.login(datos[:email], datos[:password])
      if person
        render json: person.as_json({
          :only => [:id,:names,:email,:session_token,:ci],
          methods: [:student,:professor,:administrator]
        })
      else
        render json: { "error" => "incorrect user" }, status: :unauthorized
      end
  end

  def reLogIn
      datos = params.require(:person).permit(:session_token)
      person = Person.where(session_token: datos[:session_token]).take
      if person
        person = person.login(person.email, person.password)
        render json: person.as_json({
          :only => [:id,:names,:email,:session_token,:ci],
          methods: [:student,:professor,:administrator]
        })
      else
        render json: { "error" => "incorrect session token" }, status: :unauthorized
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
