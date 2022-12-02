class ChangeUniqueToBeMultiAttr < ActiveRecord::Migration[7.0]
  def change
    remove_index :webpages, :url
    add_index :webpages, [:url, :user_id], unique: true
  end
end
