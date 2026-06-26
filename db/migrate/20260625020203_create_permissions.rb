class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
      t.string :action, null: false
      t.string :resource, null: false
      t.string :slug, null: false
      t.timestamps
    end

    add_index :permissions, :slug, unique: true
  end
end
