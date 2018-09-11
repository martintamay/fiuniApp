class ApplicationController < ActionController::API
  def return_unauthorized
    render plain: "unauthorized", status: :unauthorized
  end

  def authenticate
    token = params.require(:session_token)
    @user = Person.where(session_token: token).take

    if @user
      return true
    else
      student = Student.where(android_session_token: token).take
      if student
        @user = student.person
        return true
      else
        self.return_unauthorized
      end
    end
  end

end
