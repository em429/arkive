class AddUserIdToWebpages < ActiveRecord::Migration[7.0]
  def change
    add_column :webpages, :user_id, :integer
  end
end
