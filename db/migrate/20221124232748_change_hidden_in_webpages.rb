class ChangeHiddenInWebpages < ActiveRecord::Migration[7.0]
  change_column_default(:webpages, :hidden, from: nil, to: true)
end
