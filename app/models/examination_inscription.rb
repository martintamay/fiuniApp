class ExaminationInscription < ApplicationRecord
  belongs_to :examination
  belongs_to :taken
  has_one :note

  before_save :before_save_actions

  def as_json(options)
    if !options[:only]
      options[:only] = [:id,:approved,:inscription_date,:examination_id]
    end
    if !options[:include]
      options[:include] = {
        taken: {
          only: [:id],
          include: {
            student: {
              only: [:id],
              include: {
                person: {
                  only: [:names, :ci]
                }
              }
            }
          }
        }
      }
    end
    super(options)
  end

  def before_save_actions
    if self.approved == nil
      self.approved = 3
    end
  end
end
