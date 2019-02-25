class AddExaminationInscriptionToNote < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :examination_inscription, foreign_key: true
    remove_reference :notes, :examination, foreign_key: true
    remove_reference :notes, :taken, foreign_key: true
  end
end
