class AddDefaultWhereMissing < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :admin, false
    
  end
end
