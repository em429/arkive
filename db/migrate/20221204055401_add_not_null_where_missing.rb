class AddNotNullWhereMissing < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :name, false
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
    change_column_null :users, :remember_digest, false

    change_column_null :webpages, :user_id, false
  end
end
