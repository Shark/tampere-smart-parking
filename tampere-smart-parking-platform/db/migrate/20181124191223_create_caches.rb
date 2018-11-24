class CreateCaches < ActiveRecord::Migration[5.2]
  def change
    create_table :caches do |t|
      t.string :key
      t.json :content

      t.timestamps
    end

    add_index :caches, :key, unique: true
  end
end
