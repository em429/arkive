class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.timestamps
      
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false

      t.index :email, unique: true
    end

  end
end
