class Student < ApplicationRecord
  belongs_to :career
  belongs_to :person
  has_many :takens


  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:entry_year], include: {career: {only: [:description]}, person: {only: [:names, :email, :ci]}} )
    else
      super(options)
    end
  end

  def notesFrom(initDate)
    takens = self.takens
    notas = []
    takens.each do |taken|
      notas.concat(taken.notes.where("takenDate > ? ", initDate))
    end
    return notas
  end
end
