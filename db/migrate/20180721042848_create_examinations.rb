class CreateExaminations < ActiveRecord::Migration[5.1]
  def change
    create_table :examinations do |t|
      t.string :examination_type
      t.date :examination_date
      t.references :subject, foreign_key: true

      t.timestamps
    end
  end
end
