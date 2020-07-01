class CreateSourceFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :source_files, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :post_id,          null: false
      t.string :file_name, 	    null: false
      t.integer :total_row,     null: false
      t.datetime :published_at, null: false

      t.timestamps
    end

    add_index :source_files, :file_name, :unique => true
    add_index :source_files, :post_id
  end
end
