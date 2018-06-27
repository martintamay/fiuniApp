class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :semester
      t.references :professor, foreign_key: true

      t.timestamps
    end
  end
end
