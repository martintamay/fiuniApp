class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.integer :entry_year
      t.references :career, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
