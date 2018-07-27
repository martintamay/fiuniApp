class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]

  def index
    people = Person.all
    render json: people
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      render json: @person, status: :created, location: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def update
    if @person.update(person_params)
      render json: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @person
  end

  def destroy
    @person.destroy
  end

  def logIn
      datos = params.require(:person).permit(:email,:password)
      person = Person.login(datos[:email], datos[:password])
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
      person = Person.relogin(datos[:session_token])
      if person
        render json: person.as_json({
          :only => [:id,:names,:email,:session_token,:ci],
          methods: [:student,:professor,:administrator]
        })
      else
        render json: { "error" => "incorrect session token" }, status: :unauthorized
      end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:names, :email, :password, :ci)
    end
end
