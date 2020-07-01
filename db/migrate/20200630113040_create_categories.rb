class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories, id: false do |t|
      t.string :id, limit: 36,    primary_key: true, null: false
      t.string :post_id,   		        null: false
      t.string :source_file_id, 	      null: false
      t.string :name, 				    null: false

      t.timestamps
    end

    add_index :categories, :name
    add_index :categories, :post_id
    add_index :categories, :source_file_id
  end
end
