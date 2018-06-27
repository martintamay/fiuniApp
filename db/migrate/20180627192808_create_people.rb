class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :names
      t.string :email
      t.string :password
      t.string :ci
      t.string :session_token

      t.timestamps
    end
  end
end
