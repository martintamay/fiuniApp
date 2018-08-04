class AddExaminationToNote < ActiveRecord::Migration[5.1]
  def change
    remove_column :notes, :noteType
    remove_column :notes, :takenDate
    add_reference :notes, :examination, foreign_key: true
  end
end
