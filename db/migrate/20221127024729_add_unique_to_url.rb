class AddUniqueToUrl < ActiveRecord::Migration[7.0]
  def change
    add_index :webpages, :url, unique: true
  end
end
