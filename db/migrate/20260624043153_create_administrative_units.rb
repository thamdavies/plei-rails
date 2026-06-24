class CreateAdministrativeUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :administrative_units, id: false do |t|
      t.integer :id, null: false, primary_key: true
      t.string :full_name, limit: 255
      t.string :full_name_en, limit: 255
      t.string :short_name, limit: 255
      t.string :short_name_en, limit: 255
      t.string :code_name, limit: 255
      t.string :code_name_en, limit: 255
    end

    add_index :administrative_units, :code_name, unique: true
  end
end
