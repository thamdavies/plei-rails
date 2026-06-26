class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :summary
      t.text :description
      t.text :body
      t.integer :status, null: false, default: 0
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :status
  end
end
