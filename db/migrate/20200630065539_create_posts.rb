class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :title
      t.string :slug, unique: true
      t.integer :current_year
      t.integer :current_month
      t.integer :current_date
      
      t.timestamps
    end

    add_index :posts, :title
    add_index :posts, :slug
    add_index :posts, :current_year
    add_index :posts, :current_month
    add_index :posts, :current_date
    add_index :posts, [:current_year, :current_month, :current_date]
  end
end
