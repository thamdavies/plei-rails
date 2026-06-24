class CreateWards < ActiveRecord::Migration[8.1]
  def change
    create_table :wards, id: false, primary_key: :code do |t|
      t.string :code, null: false, limit: 20
      t.string :name, null: false, limit: 255
      t.string :name_en, limit: 255
      t.string :full_name, limit: 255
      t.string :full_name_en, limit: 255
      t.string :code_name, limit: 255
      t.string :province_code, limit: 20
      t.integer :administrative_unit_id
    end

    add_index :wards, :province_code
    add_index :wards, :administrative_unit_id

    add_foreign_key :wards, :provinces, column: :province_code, primary_key: :code
    add_foreign_key :wards, :administrative_units
  end
end
