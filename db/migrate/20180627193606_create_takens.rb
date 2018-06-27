class CreateTakens < ActiveRecord::Migration[5.1]
  def change
    create_table :takens do |t|
      t.date :inscriptionDate
      t.integer :finished
      t.date :finish_date
      t.references :student, foreign_key: true
      t.references :subject, foreign_key: true

      t.timestamps
    end
  end
end
