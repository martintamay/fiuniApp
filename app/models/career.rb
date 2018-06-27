class Career < ApplicationRecord
  has_many :students

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:description])
    else
      super(options)
    end
  end
end
