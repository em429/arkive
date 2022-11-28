class AddContentToWebpages < ActiveRecord::Migration[7.0]
  def change
    add_column :webpages, :content, :text
  end
end
