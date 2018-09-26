class Student < ApplicationRecord
  belongs_to :career
  belongs_to :person
  has_many :takens
  has_many :notes, through: :takens
  has_many :examination_inscriptions, through: :takens


  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:entry_year], \
        include: {
          person: { :only => [:email,:ci,:names] },
          career: { :only => [:id,:description] }
        })
    else
      super(options)
    end
  end

  def currentSubjects
    takens = self.takens.where(finished: 0)
    materias = []
    takens.each do |taken|
      materias.push(taken.subject)
    end
    return materias
  end

  def subjects
    takens = self.takens
    materias = []
    takens.each do |taken|
      materias.push(taken.subject)
    end
    return materias
  end

  def notesFrom(initDate)
    takens = self.takens
    notas = []
    takens.each do |taken|
      notas.concat(taken.notes.where("takenDate > ? ", initDate))
    end
    return notas
  end

  def generateSessionToken
    date = Time.now.strftime("%d%m%Y%R")
    password = self.person.password
    email = self.person.email
    self.android_session_token = Digest::SHA1.hexdigest date+password+email+SecureRandom.hex
    self.save
  end

  #métodos de clase
  def self.login(email, password)
    student  = Student.joins(:person).where("email = ? AND password = ?", email, Digest::SHA1.hexdigest(password)).take
    if student
      student.generateSessionToken()
    end
    return student
  end
end
