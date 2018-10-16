class AddValidationHashToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :validation_hash, :string
  end
end
