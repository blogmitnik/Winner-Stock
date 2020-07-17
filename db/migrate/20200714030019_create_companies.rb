class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :post_id,                null: false
      t.string :source_file_id,         null: false
      t.string :category_id,            null: false
      t.string :stock_no,      			    null: false #股票代號
      t.string :name, 					        null: false #公司名稱
      t.string :eng_name, 				      null: false #公司英文名稱
      t.string :industry_name, 			    null: true #產業名稱
      t.string :sub_industry_name, 		  null: true #子產業名稱
      t.text :main_business, 			      null: true #主要經營業務
      t.integer :capital,       		    null: false, limit: 8 #資本額
      t.datetime :founded_date,  	      null: false #公司成立時間
      t.integer :issued_common_stock,   null: false, limit: 8 #已發行普通股股數
      t.integer :par_value_per_share,   null: false, limit: 8 #普通股每股面額
      t.string :stock_market,           null: false #上市櫃市場名稱（上市:TWSE、上櫃:TPEX）

      t.timestamps
    end

    add_index :companies, :post_id
    add_index :companies, :source_file_id
    add_index :companies, :category_id
    add_index :companies, :name
    add_index :companies, :stock_no
  end
end
