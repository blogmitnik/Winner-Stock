import os
import csv
import time
from datetime import datetime
from pathlib import Path
import requests
import re
from lxml import html
import requests
from bs4 import BeautifulSoup
import pymysql #pip3 install PyMySQL

# [1] Connect to database to get all unique stock numbers and save it to list
db_conn = pymysql.connect (host='localhost',  user='',  passwd='',  db='winner_stock_development') 
cursor = db_conn.cursor () 
cursor.execute("SELECT DISTINCT `mi_reports`.`stock_code` FROM `mi_reports`")

# Fetch a single row using fetchone() method.
values = cursor.fetchall()

stock_no_list = []

# Put all unique stock_no values in to list
for key in values:
    if len(key[0]) > 4:
        continue
    stock_no_list.append(str(key[0]))

print(len(stock_no_list), "stocks were found in database")
print(stock_no_list)

# close database connection
db_conn.close()


# [2] Download and save data to CSV file
def save_csvfile(stock_no):
    print("Start crawling ", stock_no, "TWSE company data and saving to csvfile...")
    try:
        home_path = str(Path.home())
        csv_folder = 'company_csv'
        write_path = os.path.join(home_path, csv_folder)
        check_url = "https://mops.twse.com.tw/mops/web/ajax_t05st03"
        headers = {'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36'}
        params = {'oldKeyWord':stock_no, 'subMenuID':'1', 'step':'1', 'firstin':'true', 'off':'1', 'keyword4':'', 'code1':'', 'TYPEK2':'', 'checkbtn':'', 'queryName':stock_no, 'inpuType':stock_no, 'TYPEK':'all', 'co_id':stock_no, 'button':' 查詢 ' }
        resp = requests.post(check_url, data=params, headers=headers, timeout=10)

        if resp.status_code == 200:
            resp.encoding = resp.apparent_encoding
            if "公司不存在" in resp.text:
                print(stock_no, "stock doesn't exist")
            elif "不繼續公開發行" in resp.text:
                print(stock_no, "stock doesn't publicly issue anymore")
            elif "公司已下市" in resp.text:
                print(stock_no, "has been delisted")
            elif "查詢過於頻繁" in resp.text:
                print('Overrun...delaying 10 seconds')
                time.sleep(10)
            else:
                soup = BeautifulSoup(resp.text, 'lxml')
                table = soup.find_all("table", class_="hasBorder")[0]
                output_rows = []
                header_rows = []
                column_rows = []

                # Fetch header columns value for output csv
                for table_row in table.findAll('tr'):
                    headers = table_row.findAll('th')
                    # We need to filter some alternative header columns that contain no value (will cause error while importing CSV data!)
                    for header in headers:
                        if header.text == "本公司" or header.text == "取得係屬科技事業暨其產品或技術開發成功且具有市場性之明確意見書":
                            continue
                        header_rows.append(header.text)
                output_rows.append(header_rows)

                # Fetch header values for output csv
                for table_row in table.findAll('tr'):
                    columns = table_row.findAll('td')
                    
                    for column in columns:
                        column_rows.append(column.text.replace('\xa0', '').replace('\n', '').replace('\u3000', '').replace(' ', ''))
                output_rows.append(column_rows)

                # Write data to csv file
                with open(os.path.join(write_path, 'TWSE-' + stock_no + '.csv'), 'w', encoding='utf8', newline='') as csvfile:
                    writer = csv.writer(csvfile)
                    writer.writerows(output_rows)
            time.sleep(5)
            print('Delaying process for 5 seconds...')
    except Exception as ex:
        print(str(ex))
        print('Delaying process for 10 seconds...')
        time.sleep(10)
        pass
        #exit(0)

if __name__ == "__main__":
    for stock_no in stock_no_list:
        save_csvfile(stock_no)

