class FixTypeNameColumnOnNotes < ActiveRecord::Migration[5.1]
  def change
    rename_column :notes, :type, :noteType
  end
end
