class Examination < ApplicationRecord
  belongs_to :subject, optional: false
  has_many :examination_inscriptions
  has_many :notes, through: :examination_inscriptions

  def as_json(options={})
    if !options[:only]
      options[:only] = [:id,:examination_date,:examination_type]
    end
    if !options[:include]

      options[:include] = {
        subject: {
          only: :id,
          include: {
            career: {
              only: :id
            }
          }
        },
        notes: {
          only: [:id,:type,:opportunity,:score,:percentage,:checked],
          methods: [:student]
        }
      }
    end
    super(options)
  end
end
