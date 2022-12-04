class RemoveNotNullFromRememberDigest < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :remember_digest, true
  end
end
