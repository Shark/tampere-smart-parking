class AddInvalidatedToCaches < ActiveRecord::Migration[5.2]
  def change
    add_column :caches, :invalidated, :boolean, default: false
    Cache.update_all(invalidated: false)
    change_column_null :caches, :invalidated, false
  end
end
