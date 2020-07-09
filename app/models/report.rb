require 'fileutils'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class Report < ApplicationRecord
  #attr_accessible :id, :post_id, :source_file_id, :category_id, :category_name, :traded_shares_num, :turnover, :total_transactions, :advance_decline_idx, :shares_percentage, :closing_percentage, :published_at, :p_year, :p_month, :p_date, :created_at, :updated_at
  belongs_to :post
  belongs_to :source_file
  belongs_to :category
  validates :post_id, :source_file_id, :category_id, :category_name, :traded_shares_num, :turnover, :total_transactions, :advance_decline_idx, :shares_percentage, :closing_percentage, :published_at, :p_year, :p_month, :p_date, presence: true

  paginates_per 1000

  before_validation do
    if published_at
      self.p_year = published_at.year
      self.p_month = published_at.month
      self.p_date = published_at.mday
    end
  end

  before_validation :set_uuid, on: :create

  def set_uuid
    self.id = SecureRandom.uuid
  end

  SORT_NAMES = %w(
    published_at category_name
  )

  def self.sort_names
    SORT_NAMES
  end

  def self.group_shares_percentage_by_date(date_time)
    reports = where("published_at = ?", date_time)
    reports = reports.group("category_name")
    reports = reports.select("category_name, max(shares_percentage) as best_shares_percentage")
    reports = reports.order("best_shares_percentage DESC")
  end

  def self.group_closing_percentage_by_date(date_time)
    reports = where("published_at = ?", date_time)
    reports = reports.group("category_name")
    reports = reports.select("category_name, max(closing_percentage) as best_closing_percentage")
    reports = reports.order("best_closing_percentage DESC")
  end

  # The 'import' function can be used both on web and rake script
  def self.import_data(file, filename, post)
    # Check filename
    if csvfile = SourceFile.find_by_file_name(filename)
      csvfile_id = csvfile.id
    else
      line_count = CSV.open(file, "r", :encoding => 'big5').readlines.count - 1
      file_date = Time.parse(filename.gsub('.csv', '')).strftime('%Y-%m-%d %H:%M:%S').to_s
      uuid = SecureRandom.uuid
      source_file = SourceFile.create(id: uuid, post_id: post.id, file_name: filename, total_row: line_count, published_at: file_date)
      csvfile_id = source_file.id
    end

    GC.disable

    Report.transaction do
      records = []
      columns = [:id, :post_id, :source_file_id, :category_id, :category_name, :traded_shares_num, :turnover, :total_transactions, :advance_decline_idx, :shares_percentage, :closing_percentage, :published_at, :p_year, :p_month, :p_date]
      column_header = ['分類指數名稱', '成交股數', '成交金額', '成交筆數', '漲跌指數']
      
      sum_of_shares = 0
      sum_of_closing = 0
      CSV.foreach(file, **{encoding: "big5", quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
          # We only need data from row "水泥類指數" to "其他類指數"
          if rowno > 1 and rowno < line_count-2
            sum_of_shares += row['成交股數'].gsub(',', '').to_i
            sum_of_closing += row['成交金額'].gsub(',', '').to_i
          end
      end
      
      CSV.foreach(file, **{encoding: "big5", quote_char: '"', col_sep: ',', row_sep: :auto, headers: column_header}).with_index(0) do |row, rowno|
        if rowno > 1 and rowno < line_count-2
          if category = Category.find_by_name(row['分類指數名稱'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('工業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s)
            category_id = category.id
          else
            c_uuid = SecureRandom.uuid
            category = Category.create(id: c_uuid, post_id: post.id, name: row['分類指數名稱'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('工業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s)
            category_id = category.id
          end

          shares_percentage = ((row['成交股數'].gsub(',', '').to_f / sum_of_shares.to_f) * 100).round(2)
          closing_percentage = ((row['成交金額'].gsub(',', '').to_f / sum_of_closing.to_f) * 100).round(2)

          time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s
          report_uuid = SecureRandom.uuid
          record = [report_uuid, post.id, csvfile_id, category_id, row['分類指數名稱'].gsub('醫療', '醫').gsub('百貨貿易', '貿易百貨').gsub('營造建材', '建材營造').gsub('運輸', '航運業').gsub('事業', '').gsub('工業', '').gsub('它', '他').gsub('類', '').gsub('指', '').gsub('數', '').gsub('　', '').strip.to_s, row['成交股數'].gsub(',', ''), row['成交金額'].gsub(',', ''), row['成交筆數'].gsub(',', ''), row['漲跌指數'],
            shares_percentage, closing_percentage,
            Time.parse(filename.gsub('.csv', '')).strftime('%Y-%m-%d %H:%M:%S').to_s, Time.parse(filename.gsub('.csv', '').to_s).year, Time.parse(filename.gsub('.csv', '').to_s).month, Time.parse(filename.gsub('.csv', '').to_s).day,
            time_now, time_now]
          records << record
        end
      end

      
      values = records.map{ |record| "('#{record[0]}', '#{record[1]}', '#{record[2]}', '#{record[3]}', '#{record[4]}', #{record[5]}, #{record[6]}, #{record[7]}, #{record[8]}, #{record[9]}, #{record[10]}, '#{record[11]}', #{record[12]}, #{record[13]}, #{record[14]}, '#{record[15]}', '#{record[16]}')" }.join(",")
      sql = "INSERT INTO `#{self.table_name}` (`id`,`post_id`,`source_file_id`,`category_id`,`category_name`,`traded_shares_num`,`turnover`,`total_transactions`,`advance_decline_idx`,`shares_percentage`,`closing_percentage`,`published_at`,`p_year`,`p_month`,`p_date`,`created_at`,`updated_at`) VALUES #{values}"
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn.execute(sql)
      end
    end

    the_year = filename[0, 4]
    the_month = filename[4, 2]
    the_date = filename[6, 2]
    post.update_attributes(current_year: the_year, current_month: the_month, current_date: the_date)
  end
end
