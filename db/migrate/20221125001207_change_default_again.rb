class ChangeDefaultAgain < ActiveRecord::Migration[7.0]
  change_column_default(:webpages, :hidden, from: true, to: false)
end
