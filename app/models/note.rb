#TODO: agregar anulado y hacer que  devuelva el no anulado siempre
# para que se puedan corregir notas cargadas erroneamente

class Note < ApplicationRecord
  belongs_to :examination_inscription
  has_one :taken, through: :examination_inscription
  has_one :examination, through: :examination_inscription

  before_save :set_note
  after_save :check_finished

  after_initialize :init

  def as_json(options={})
    if(!options[:only])
      options[:only] = [:id,:opportunity,:score,:percentage,:checked]
    end
    if(!options[:include])
      options[:include] = {
        examination: {
          only: [:id,:examination_date,:examination_type]
        }
      }
    end
    if(!options[:methods])
      options[:methods] = [:student]
    end
    generated = super(options)
    generated[:subject] = self.subject.as_json({ only: [:id], include: [] })
    return generated
  end

  def subject
    self.taken.subject
  end

  def student
    self.taken.student
  end

  def set_note
    if self.percentage < 60
      self.score = 1
    elsif self.percentage < 70
      self.score = 2
    elsif self.percentage < 80
      self.score = 3
    elsif self.percentage < 90
      self.score = 4
    else
      self.score = 5
    end

    #se setea la oportunidad la correcta
    if !self.opportunity
      lastOpportunity = Note.joins(:examination_inscription).where(
        "examination_inscriptions.taken_id = ?", self.taken.id
      ).maximum('opportunity')
      self.opportunity = lastOpportunity ? lastOpportunity+1 : 1
    end
  end

  def check_finished
    #se busca el ultimo final que rindio
    final = self.taken.notes.joins(:examination).where(
      {
        examinations: {
          examination_type: 'Final'
        }
      }).order('examinations.examination_date').last
    #si aun no rindio ningun final o no paso el ultimo que rindio se termina el metodo
    if !final || final.percentage<60
      return false
    end

    #si encontro un final aprobado se busca el ultimo pp obtenido
    pp = self.taken.notes.joins(:examination).where(
      {
        examinations: {
          examination_type: 'PP'
        }
      }).order('examinations.examination_date').last

    #si tiene mas de 50 de pp y el pp*0.4+final*0.6>60 se marca como aprobado
    #si no se marca como no aprobado
    if (pp && pp.percentage>=50 && pp.percentage*0.4 + final.percentage*0.6 >= 60)
      final.taken.finished = 1
      final.taken.finish_date = final.examination.examination_date
    else
      final.taken.finished = 0
      final.taken.finish_date = nil
    end
  end

  def init
    #se marca como sin revisar
    if !self.checked
      self.checked = 0
    end
  end
end
