require 'securerandom'

class Person < ApplicationRecord
  def as_json(options={})
    if(options[:only]==nil)
      super({
        :only => [:id,:names,:email,:password,:ci],
        methods: [:student,:professor,:administrator]
      })
    else
      super(options)
    end
  end

  #métodos de objeto
  def student
    st = Student.where("person_id = ?", self.id).take
    st.as_json :only => [:id,:entry_year]
  end
  def professor
    pr = Professor.where("person_id = ?", self.id).take
    pr.as_json :only => [:id,:entry_year]
  end
  def administrator
    ad = Administrator.where("person_id = ?", self.id).take
    ad.as_json :only => [:id,:entry_year]
  end

  def login(email, password)
    person  = Person.where("email = ? AND password = ?", email, password).take
    if person
      person.generateSessionToken()
    end
    return person
  end

  def generateSessionToken
    date = Time.now.strftime("%d%m%Y%R")
    password = self.password
    email = self.email
    self.session_token = Digest::SHA1.hexdigest date+password+email+SecureRandom.hex
    self.save
  end
end
