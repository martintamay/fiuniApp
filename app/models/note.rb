class Note < ApplicationRecord
  belongs_to :taken

  def as_json(options={})
    if(options[:only]==nil)
      super(:only => [:id,:type,:opportunity,:takenDate,:score,:taken,:percentage,:checked])
    else
      super(options)
    end
  end
end
