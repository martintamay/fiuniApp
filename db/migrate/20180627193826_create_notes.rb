class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :type
      t.date :takenDate
      t.integer :score
      t.integer :approved
      t.integer :percentage
      t.references :taken, foreign_key: true

      t.timestamps
    end
  end
end
