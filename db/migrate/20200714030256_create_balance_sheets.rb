class CreateBalanceSheets < ActiveRecord::Migration[6.0]
  def change
  	#建立資產負債表
    create_table :balance_sheets, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :company_id,              		null: false
      t.string :source_file_id,           		null: false
      t.string :stock_no,      					null: false #股票代號
      t.integer :year,	 						null: false #年度
      t.integer :quarter, 						null: false #季度(1~4)
      t.integer :fixed_asset,		       		null: false, limit: 8 #固定資產（非流動資產合計）
      t.integer :asset,							null: false, limit: 8 #總資產
      t.integer :current_liability,				null: false, limit: 8 #其他流動負債
      t.integer :liability,						null: false, limit: 8 #總負債（負債總計）
      t.integer :share_capital,					null: false, limit: 8 #股本
      t.integer :additional_paid_in_capital,	null: false, limit: 8 #資本公積
      t.integer :retained_earnings,				null: false, limit: 8 #保留盈餘

      t.timestamps
    end

    add_index :balance_sheets, :company_id
    add_index :balance_sheets, :source_file_id
    add_index :balance_sheets, [:stock_no, :year, :quarter]
  end
end
