class Person < ApplicationRecord

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:names,:email,:password,:ci])
    else
      super(options)
    end
  end
end
