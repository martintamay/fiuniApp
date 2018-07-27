class AddCareerToSubject < ActiveRecord::Migration[5.1]
  def change
    add_reference :subjects, :career, foreign_key: true
  end
end
