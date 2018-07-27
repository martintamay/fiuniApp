class Subject < ApplicationRecord
  belongs_to :professor, optional: true
  belongs_to :career
  has_many :takens

  def as_json(options={})
    #si no especificó un only se usa el siguiente
    if(!options[:only])
      options[:only] = [:id,:name,:semester]
    end
    if(!options[:include])
      options[:include] = [
        professor: {
          only: :id,
          include: {
            person: {
              only: [:id,:names]
            }
          }
        }
      ]
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
    end
  end

  #SCOPES
  #scope :uncheckeds => Note.joins(:taken).where(checked: 0).group("takens.subject_id")
end
