class Note < ApplicationRecord
  belongs_to :taken
  belongs_to :examination

  after_initialize :init

  def as_json(options={})
    if(!options[:only])
      options[:only] = [:id,:type,:opportunity,:score,:percentage,:checked]
    end
    if(!options[:include])
      options[:include] = {
        examination: {
          only: [:id,:examination_date,:examination_type],
          include: { subject: { only: :id } }
        }
      }
    end
    if(!options[:methods])
      options[:methods] = [:student]
    end
    super(options)
  end

  def student
    self.taken.student
  end

  def init
    #se marca como sin revisar
    if !self.checked
      self.checked = 0
    end

    #se setea la oportunidad la correcta
    if !self.opportunity
      lastOpportunity = self.taken.notes.where(noteType: self.examination.test_type).maximum('opportunity')
      self.opportunity = lastOpportunity ? lastOpportunity+1 : 1
    end
  end
end
