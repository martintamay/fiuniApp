class PeopleController < ApplicationController
  before_action :authenticate, except: [:reLogIn, :logIn]
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :check_access, only: [:index, :destroy, :create]
  before_action :check_access_or_owner, only: [:update, :show]

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

    def check_access
      if(!@user.is_administrator)
        return_unauthorized
      end
    end

    def check_access_or_owner
      if !(@user.is_administrator || @user = @person)
        return_unauthorized
      end
    end

end
