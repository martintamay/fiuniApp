class Professor < ApplicationRecord
  belongs_to :person
  has_many :subjects

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:person])
    else
      super(options)
    end
  end
end
