class Subject < ApplicationRecord
  belongs_to :professor, optional: true

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:name,:semester,:profesor])
    else
      super(options)
    end
  end
end
