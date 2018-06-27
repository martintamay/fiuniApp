class Taken < ApplicationRecord
  belongs_to :student
  belongs_to :subject

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:student,:subject,:inscription,:finished,:finish_date])
    else
      super(options)
    end
  end
end
