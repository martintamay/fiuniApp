class Student < ApplicationRecord
  belongs_to :career
  belongs_to :person
  has_many :takens


  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:person,:entry_year,:career])
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
