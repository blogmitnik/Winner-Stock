require 'fileutils'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class Company < ApplicationRecord
  belongs_to :post
  belongs_to :category
  belongs_to :source_file
  has_many :income_statements, dependent: :destroy
  has_many :balance_sheets, dependent: :destroy

  validates :post_id, :category_id, :source_file_id, :stock_no, :name, :eng_name, :capital, :founded_date, :issued_common_stock, :par_value_per_share, :stock_market, presence: true

  before_validation :set_uuid, on: :create

  paginates_per 100

  self.implicit_order_column = "stock_no"

  def set_uuid
    self.id = SecureRandom.uuid
  end

  # The 'import' function can be used both on web and rake script
  def self.import_data(file, filename, post)
    # Check filename
    if csvfile = SourceFile.find_by_file_name(filename)
      csvfile_id = csvfile.id
    else
      line_count = CSV.open(file, "r", :encoding => 'utf-8').readlines.count
      file_today = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s
      uuid = SecureRandom.uuid
      source_file = SourceFile.create(id: uuid, post_id: post.id, file_name: filename, total_row: line_count, published_at: file_today)
      csvfile_id = source_file.id
    end

    GC.disable

    Report.transaction do
      records = []
      # Define header columns in the csv file
      #column_header = ["股票代號", "產業類別", "外國企業註冊地國", "公司名稱", "總機", "地址", "董事長", "總經理", "發言人", "發言人職稱", "發言人電話", "代理發言人", "主要經營業務", "公司成立日期", "營利事業統一編號", "實收資本額", "上市日期", "上櫃日期", "興櫃日期", "公開發行日期", "普通股每股面額", "已發行普通股數或TDR原股發行股數", "特別股", "普通股盈餘分派或虧損撥補頻率", "普通股年度 (含第4季或後半年度)現金股息及紅利決議層級", "股票過戶機構", "電話", "過戶地址", "簽證會計師事務所", "簽證會計師1", "簽證會計師2", "備註", "特別股發行", "公司債發行", "英文簡稱", "英文全名", "英文通訊地址(街巷弄號)", "英文通訊地址(縣市國別)", "傳真機號碼", "電子郵件信箱", "公司網址", "投資人關係聯絡人", "投資人關係聯絡人職稱", "投資人關係聯絡電話", "投資人關係電子郵件", "公司網站內利害關係人專區網址", "變更前名稱", "變更前簡稱", "公司名稱變更核准日期"]
	  column_header = CSV.read(file, headers: true).headers

      CSV.foreach(file, **{encoding: 'utf-8', quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
        if rowno >= 1 and rowno < line_count
          if category = Category.find_by_name(row['產業類別'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('工業', '').gsub('業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s)
            category_id = category.id
          else
          	c_uuid = SecureRandom.uuid
            category = Category.create(id: c_uuid, post_id: post.id, name: row['產業類別'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('業', '').gsub('工業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s)
            category_id = category.id
          end

          begin
          	stock_no = row['股票代號']
          	company_name = row['公司名稱']
	      	company_eng_name = row['英文全名'].gsub('\'', '').gsub('’', '')
          	category_name = row['產業類別'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('工業', '').gsub('業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s
          	main_business = row['主要經營業務']
          	capital = row['實收資本額'].gsub('元', '').gsub(',', '').to_i
          	issued_common_stock = row['已發行普通股數或TDR原股發行股數'].gsub(',', '').gsub(' ', '').split("股(").first.to_i
          	par_value_per_share = row['普通股每股面額'].gsub('元', '').gsub('新台幣', '').to_i
          	stock_market = "TWSE"
          	founded_year = (row['公司成立日期'].split("/")[0].to_i + 1911).to_s
          	founded_month = row['公司成立日期'].split("/")[1].to_s
          	founded_day = row['公司成立日期'].split("/")[2].to_s
          	founded_date = Time.parse(founded_year + founded_month + founded_day).strftime('%Y-%m-%d %H:%M:%S').to_s
          	time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s
          	company_uuid = SecureRandom.uuid

          	record = [company_uuid, post.id, category_id, csvfile_id, 
          		stock_no, company_name, company_eng_name, 
          		category_name, "暫無", main_business, capital, founded_date, 
          		issued_common_stock, par_value_per_share, stock_market, time_now, time_now]
          	records << record
          rescue ArgumentError => error
          	#puts error.inspect
          	SourceFile.destroy_by(file_name: filename)
          end
        end
      end

      values = records.map{ |record| "('#{record[0]}', '#{record[1]}', '#{record[2]}', '#{record[3]}', '#{record[4]}', '#{record[5]}', '#{record[6]}', '#{record[7]}', '#{record[8]}', '#{record[9]}', #{record[10]}, '#{record[11]}', #{record[12]}, #{record[13]}, '#{record[14]}', '#{record[15]}', '#{record[16]}')" }.join(",")
      sql = "INSERT INTO `#{self.table_name}` (`id`,`post_id`,`category_id`,`source_file_id`,`stock_no`,`name`,`eng_name`,`industry_name`,`sub_industry_name`,`main_business`,`capital`,`founded_date`,`issued_common_stock`,`par_value_per_share`,`stock_market`,`created_at`,`updated_at`) VALUES #{values}"
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn.execute(sql)
      end
    end
  end

  def self.renew_data(file, filename, company)
  	csvfile = SourceFile.find_by_file_name(filename)
    csvfile_id = csvfile.id
    company_id = company.id

    # Define header columns in the csv file
	#column_header = ["股票代號", "產業類別", "外國企業註冊地國", "公司名稱", "總機", "地址", "董事長", "總經理", "發言人", "發言人職稱", "發言人電話", "代理發言人", "主要經營業務", "公司成立日期", "營利事業統一編號", "實收資本額", "上市日期", "上櫃日期", "興櫃日期", "公開發行日期", "普通股每股面額", "已發行普通股數或TDR原股發行股數", "特別股", "普通股盈餘分派或虧損撥補頻率", "普通股年度 (含第4季或後半年度)現金股息及紅利決議層級", "股票過戶機構", "電話", "過戶地址", "簽證會計師事務所", "簽證會計師1", "簽證會計師2", "備註", "特別股發行", "公司債發行", "英文簡稱", "英文全名", "英文通訊地址(街巷弄號)", "英文通訊地址(縣市國別)", "傳真機號碼", "電子郵件信箱", "公司網址", "投資人關係聯絡人", "投資人關係聯絡人職稱", "投資人關係聯絡電話", "投資人關係電子郵件", "公司網站內利害關係人專區網址", "變更前名稱", "變更前簡稱", "公司名稱變更核准日期"]
	column_header = CSV.read(file, headers: true).headers

	CSV.foreach(file, **{encoding: 'utf-8', quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
	  if rowno == 1
	    # CSV columns those might be updated
	    company_name = row['公司名稱']
	    company_eng_name = row['英文全名'].gsub('\'', '').gsub('’', '')
	    category_name = row['產業類別'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('工業', '').gsub('業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s
	    main_business = row['主要經營業務']
	    capital = row['實收資本額'].gsub('元', '').gsub(',', '').to_i
	    issued_common_stock = row['已發行普通股數或TDR原股發行股數'].gsub(',', '').gsub(' ', '').split("股(").first.to_i
	    par_value_per_share = row['普通股每股面額'].gsub('元', '').gsub('新台幣', '').to_i
	    founded_year = (row['公司成立日期'].split("/")[0].to_i + 1911).to_s
	    founded_month = row['公司成立日期'].split("/")[1].to_s
	    founded_day = row['公司成立日期'].split("/")[2].to_s
	    founded_date = Time.parse(founded_year + founded_month + founded_day).strftime('%Y-%m-%d %H:%M:%S').to_s
	    time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s

	    sql = "UPDATE `#{self.table_name}` SET `#{self.table_name}`.name = '#{company_name}', 
		  `#{self.table_name}`.eng_name = '#{company_eng_name}', 
		  `#{self.table_name}`.industry_name = '#{category_name}', 
		  `#{self.table_name}`.main_business = '#{main_business}',
		  `#{self.table_name}`.capital = '#{capital}',
		  `#{self.table_name}`.issued_common_stock = '#{issued_common_stock}',
		  `#{self.table_name}`.par_value_per_share = '#{par_value_per_share}',
		  `#{self.table_name}`.founded_date = '#{founded_date}',
		  `#{self.table_name}`.`updated_at` = '#{time_now}' WHERE `#{self.table_name}`.`id` = '#{company_id}'"
	    ActiveRecord::Base.connection_pool.with_connection do |conn|
	      conn.execute(sql)
	    end
	  end
	end
  end
end
