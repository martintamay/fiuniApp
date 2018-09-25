class AddExaminationInscriptionToNote < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :examination_inscription, foreign_key: true
    remove_reference :notes, :examination
    remove_reference :notes, :taken
  end
end
