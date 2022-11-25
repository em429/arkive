class RenameHiddenToReadStatus < ActiveRecord::Migration[7.0]
  def change
    rename_column(:webpages, :hidden, :read_status)
  end
end
