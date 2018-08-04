require 'securerandom'

class Person < ApplicationRecord
  validates_uniqueness_of :email
  validates_uniqueness_of :ci
  before_save :encrypt_password

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

  def generateSessionToken
    date = Time.now.strftime("%d%m%Y%R")
    password = self.password
    email = self.email
    self.session_token = Digest::SHA1.hexdigest date+password+email+SecureRandom.hex
    self.save
  end

  def encrypt_password
    if self.password_changed?
      if self.password == ''
        self.password = password_was
      elsif self.password != password_was
        self.password = Digest::SHA1.hexdigest self.password
      else
        self.password
      end
    end
  end


  #class methods
  def self.login(email, password)
    person  = Person.where("email = ? AND password = ?", email, Digest::SHA1.hexdigest(password)).take
    if person
      person.generateSessionToken()
    end
    return person
  end
  def self.relogin(session_token)
    person = Person.where(session_token: session_token).take
    if person
      person.generateSessionToken()
    end
    return person
  end
end
