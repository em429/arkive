class CreateWebpages < ActiveRecord::Migration[7.0]
  def change
    create_table :webpages do |t|
      t.timestamps
      
      t.string :title
      t.string :url, null: false
      t.string :url_md5_hash
      t.string :internet_archive_url
      t.boolean :read_status, default: false
      t.text :content
      
      t.references :user, foreign_key: true, null: false

      t.index [:url, :user_id], unique: true
    end

  end
end
