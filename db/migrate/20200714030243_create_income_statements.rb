class CreateIncomeStatements < ActiveRecord::Migration[6.0]
  def change
  	#建立損益表
    create_table :income_statements, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :company_id,              	null: false
      t.string :source_file_id,           	null: false
      t.string :stock_no,      				null: false #股票代號
      t.integer :year,	 					null: false #年度
      t.integer :quarter, 					null: false #季度(1~4)
      t.integer :total_revenue,       		null: false, limit: 8 #營業收入
      t.integer :cost_of_revenue,       	null: false, limit: 8 #營業成本
      t.integer :gross_revenue, 	    	null: false, limit: 8 #銷貨毛利
      t.integer :operating_expanse,			null: false, limit: 8 #營業費用=推銷費用+管理費用+研發費用
      t.integer :operating_balance,			null: false, limit: 8 #營業利益
      t.integer :income_before_tax,			null: false, limit: 8 #稅前淨利
      t.integer :net_income,				null: false, limit: 8 #稅後淨利
      t.integer :eps,						null: false, limit: 8 #每股盈餘

      t.timestamps
    end

    add_index :income_statements, :company_id
    add_index :income_statements, :source_file_id
    add_index :income_statements, [:stock_no, :year, :quarter]
  end
end
