require 'csv'
require 'fileutils'

desc "This task is to import TWSE company data from csv files into database"
task :import_twse_company, [:filename] => :environment do
	puts "Fetching CSV files from local folder..."
	imported_files = []
	imported_main_files = []
	imported_mini_files = []
    duplicated_files = []
	filtered_csvs_from_today = []
    no_row_files = []
    filtered_csvs = []
    check_filename_date = []
    target_folder = Dir.home + '/company_csv'
    # Define the folder of CSV files
	d = Dir.new(target_folder)
	#Dir.chdir(d)
	# This will recursively find all csv files in a given directory
	#csvs = d.entries.select {|csv| /^.+\.csv$/.match(csv)}
	filtered_csvs = Dir[ File.join(d, '**', '*.csv') ].reject { |p| File.directory? p }

	start_time = Time.now
	puts "Start importing TWSE company data at #{start_time}"
	puts '-' * 50

	filtered_csvs.select do |file|
		filename = File.basename(file).gsub('_', '-')
		line_count = `wc -l "#{file}"`.strip.split(' ')[0].to_i - 1

		puts "Start importing data from " + filename.to_s

        # Check if csv file already existed (imported) in database
        if SourceFile.exists?(file_name: filename)
        	if company = Company.find_by_stock_no(filename.gsub('.csv', ''))
        		# update colomn values for specific company (When next time importing same CSV file)
        		Company.renew_data(file, filename, company)
        		duplicated_files << file
        		puts filename.to_s + ' [duplicated and updated]'
        	end
        # Do nothing when CSV files contain no row data
        elsif line_count.equal? 0
        	no_row_files << file
        	next
        else # Process the CSV files that we actually need
        	model_stage = '上市公司指數'
        	if post = Post.find_by_title(model_stage)
        		Company.import_data(file, filename, post)
        		# Check total imported row counts
        		if file = SourceFile.find_by_file_name(filename)
        			count = Company.where(post_id: post, source_file_id: file).count
        			# Check if CSV row numbers equal to record numbers that imported to database
        			if count + 1 == file.total_row
		                imported_files << file
		                puts filename.to_s + ' [successfully imported]'
		            else
		                # If row counts are not equal, rollback all the imported rows
		                file.destroy
		                puts 'Data lost while importing data from ' + filename.to_s
		            end
		        end
		    else
		    	uuid = SecureRandom.uuid
		    	post = Post.create(id: uuid, title: model_stage)
	            # Then import data records
	            Company.import_data(file, filename, post)
	            # Check total imported row counts
	            if file = SourceFile.find_by_file_name(filename)
	            	count = Company.where(post_id: post, source_file_id: file).count
	            	# Check if CSV row numbers equal to record numbers that imported to database
	            	if count.equal? file.total_row
	            		imported_files << file
	            		puts filename.to_s + ' [successfully imported]'
	            	else
	            		# If row counts are not equal, rollback all the imported rows
	            		file.destroy
	            		puts 'Data lost while importing ' + filename.to_s
	            	end
	            end
        	end
        end
	end
	puts '-' * 50
	puts filtered_csvs.count.to_s + ' CSV file(s) processed, ' + duplicated_files.count.to_s + ' updated, ' + no_row_files.count.to_s + ' no-row file(s), and ' + (imported_files.count + imported_main_files.count + imported_mini_files.count).to_s + ' file(s) imported!'
	puts 'Data importing process completed at ' + Time.now.to_s
	end_time = Time.now
	puts "Total time: #{(end_time - start_time)} seconds"
end