class Subject < ApplicationRecord
  belongs_to :professor, optional: true
  has_many :takens

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:name,:semester,:profesor])
    else
      super(options)
    end
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
end
