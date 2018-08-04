class AddCheckedToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :checked, :integer
  end
end
