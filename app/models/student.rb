class Student < ApplicationRecord
  belongs_to :career
  belongs_to :person
  has_many :takens


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

  #métodos de objeto
  def notes
    takens = self.takens
    notas = []
    takens.each do |taken|
      notas.concat(taken.notes)
    end
    return notas
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

  #métodos de clase
  def self.login(email, password)
    student  = Student.joins(:person).where("email = ? AND password = ?", email, password).take
    if student
      student.person.generateSessionToken()
    end
    return student
  end
end
