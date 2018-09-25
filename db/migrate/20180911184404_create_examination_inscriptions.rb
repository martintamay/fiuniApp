class CreateExaminationInscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :examination_inscriptions do |t|
      t.integer :approved
      t.date :inscription_date
      t.references :examination, foreign_key: true
      t.references :taken, foreign_key: true

      t.timestamps
    end
  end
end
