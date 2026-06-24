class CreateProvinces < ActiveRecord::Migration[8.1]
  def change
    create_table :provinces, id: false, primary_key: :code do |t|
      t.string :code, null: false, limit: 20
      t.string :name, null: false, limit: 255
      t.string :name_en, limit: 255
      t.string :full_name, null: false, limit: 255
      t.string :full_name_en, limit: 255
      t.string :code_name, limit: 255
      t.integer :administrative_unit_id
    end

    add_index :provinces, :code, unique: true
    add_index :provinces, :administrative_unit_id
    add_index :provinces, :code_name, unique: true

    add_foreign_key :provinces, :administrative_units
  end
end
