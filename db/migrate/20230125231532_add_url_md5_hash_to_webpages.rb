class AddUrlMd5HashToWebpages < ActiveRecord::Migration[7.0]
  def change
    add_column :webpages, :url_md5_hash, :string
  end
end
