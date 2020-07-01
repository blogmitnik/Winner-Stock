class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :post_id,                  null: false
      t.string :source_file_id,           null: false
      t.string :category_id,              null: false
      t.string :category_name,            null: false
      t.integer :traded_shares_num,       null: false, limit: 8
      t.integer :turnover,                null: false, limit: 8
      t.integer :total_transactions,      null: false, limit: 8
      t.decimal :advance_decline_idx,     null: false, precision: 5, scale: 2
      t.float :shares_percentage,         null: false, precision: 5, scale: 2
      t.float :closing_percentage,        null: false, precision: 5, scale: 2
      t.datetime :published_at,           null: false
      t.integer :p_year,                  null: false
      t.integer :p_month,                 null: false
      t.integer :p_date,                  null: false

      t.timestamps
    end

    add_index :reports, :post_id
    add_index :reports, :source_file_id
    add_index :reports, :category_id
    add_index :reports, [:category_id, :published_at ]
    add_index :reports, :category_name
    add_index :reports, [:category_name, :published_at ]
    add_index :reports, :traded_shares_num
    add_index :reports, :turnover
    add_index :reports, :total_transactions
    add_index :reports, :advance_decline_idx
    add_index :reports, :published_at
    add_index :reports, [ :p_year, :p_month, :p_date ]
    add_index :reports, [ :category_id, :p_year, :p_month, :p_date ]
    add_index :reports, [ :category_name, :p_year, :p_month, :p_date ]
  end
end
