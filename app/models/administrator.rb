class Administrator < ApplicationRecord
  belongs_to :person

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:person])
    else
      super(options)
    end
  end
end
