class CreateWebpages < ActiveRecord::Migration[7.0]
  def change
    create_table :webpages do |t|
      t.string :title
      t.string :url
      t.string :internet_archive_url

      t.timestamps
    end
  end
end
