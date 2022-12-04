class ChangeUrlToNotNullWebpagesTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :webpages, :url, false
  end
end
