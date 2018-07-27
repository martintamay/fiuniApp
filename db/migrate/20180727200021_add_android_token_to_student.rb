class AddAndroidTokenToStudent < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :android_session_token, :string
  end
end
