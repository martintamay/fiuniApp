class CreateProfessors < ActiveRecord::Migration[5.1]
  def change
    create_table :professors do |t|
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
