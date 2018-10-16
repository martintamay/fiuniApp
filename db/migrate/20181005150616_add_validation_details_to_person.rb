class AddValidationDetailsToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :validated, :boolean
  end
end
