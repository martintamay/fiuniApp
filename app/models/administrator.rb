class Administrator < ApplicationRecord
  belongs_to :person

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id], include: :person)
    else
      super(options)
    end
  end
end
