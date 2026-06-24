class CreateAdministrativeRegions < ActiveRecord::Migration[8.1]
  def change
    create_table :administrative_regions, id: false do |t|
      t.integer :id, null: false, primary_key: true
      t.string :name, null: false, limit: 255
      t.string :name_en, null: false, limit: 255
      t.string :code_name, limit: 255
      t.string :code_name_en, limit: 255
    end

    add_index :administrative_regions, :code_name, unique: true
  end
end
