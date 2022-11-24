class AddHiddenToWebpages < ActiveRecord::Migration[7.0]
  def change
    add_column :webpages, :hidden, :boolean
  end
end
