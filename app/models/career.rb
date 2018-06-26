class Career < ApplicationRecord
  def as_json(options={})
    super(:only => [:id,:description])
  end
end
