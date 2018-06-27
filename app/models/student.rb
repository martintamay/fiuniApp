class Student < ApplicationRecord
  belongs_to :career
  belongs_to :person
end
