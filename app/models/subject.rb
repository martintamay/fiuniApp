class Subject < ApplicationRecord
  belongs_to :professor

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:name,:semester], include: {
        professor: { only: [], include:{ person:{only: [:names, :email, :ci]}}}
        })
    else
      super(options)
    end
  end
end
