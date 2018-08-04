class Subject < ApplicationRecord
  belongs_to :professor, optional: true
  belongs_to :career
  has_many :takens

  def as_json(options={})
<<<<<<< HEAD
    if(options[:only]==nil)
      super(:only => [:id,:name,:semester], include: {
        professor: { only: [], include:{ person:{only: [:names, :email, :ci]}}}
        })
    else
      super(options)
=======
    #si no especificó un only se usa el siguiente
    if(!options[:only])
      options[:only] = [:id,:name,:semester]
    end
    if(!options[:include])
      options[:include] = {
        professor: {
          only: :id,
          include: {
            person: {
              only: [:id,:names]
            }
          }
        },
        career: {
          only: :id
        }
      }
    end

    #se genera el json
    super(options)
  end

  def notes
    self.takens.map do |taken|
      taken.student.as_json(:only => [:id,:entry_year],
        include: {
          person: { :only => [:names,:ci] }
        }
      ).merge({ "notes" => taken.notes.as_json})
>>>>>>> b57fa50226e1cb4797e8e4a773e45e1e96ff79b2
    end
  end

  #SCOPES
  #scope :uncheckeds => Note.joins(:taken).where(checked: 0).group("takens.subject_id")
end
