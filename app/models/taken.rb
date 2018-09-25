class Taken < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  has_many :examination_inscriptions
  has_many :notes, through: :examination_inscriptions
  
  def as_json(options={})
    if(!options[:only])
      options[:only] = [:id,:subject_id,:inscription_date,:finished,:finish_date]
    end
    if(!options[:include])
      options[:include] = {
        student: {
          only: :id,
          include: {
            person: {
              only: [:id,:names,:ci]
            }
          }
        }
      }
    end
    super(options)
  end
end
