require 'csv'
require 'fileutils'

desc "This task is for importing MI_INDEX csv files into database"
task :import_mi_index, [:filename] => :environment do
	puts "Fetching csv files from local folder..."
	imported_files = []
	imported_main_files = []
	imported_mini_files = []
    duplicated_files = []
	filtered_csvs_from_today = []
    no_row_files = []
    filtered_csvs = []
    check_filename_date = []
    target_folder = Dir.home + '/mi_index_csv'
    # Define the folder of CSV files
	d = Dir.new(target_folder)
	#Dir.chdir(d)
	# This will recursively find all csv files in a given directory
	#csvs = d.entries.select {|csv| /^.+\.csv$/.match(csv)}
	filtered_csvs = Dir[ File.join(d, '**', '*.csv') ].reject { |p| File.directory? p }

	start_time = Time.now
	puts "Start importing MI_INDEX data at #{start_time}"
	puts '-' * 50

	#Only import today's CSV files
	date_today = DateTime.parse(Date.today.to_s).strftime('%Y%m%d')
	date_yesterday = DateTime.parse((Date.today-1).to_s).strftime('%Y%m%d')
		
	# Get latest datetime stamp from csv filename lists
	filtered_csvs.select do |file|
		filename = File.basename(file).gsub('_', '-')
		file_date = filename[12, 8]
		check_filename_date << file_date
	end
	latest_date = check_filename_date.max #ex: 20200211, This is maybe Today or Yesterday

	# For the first time import, comment out below section of codes
	# filtered_csvs.select do |file|
	# 	filename = File.basename(file).gsub('_', '-')
	# 	if filename.eql? latest_date
	# 		filtered_csvs_from_today << file
	# 	end
	# end

	filtered_csvs.select do |file|
		filename = File.basename(file).gsub('_', '-')
		# line_count = `wc -l "#{file}"`.strip.split(' ')[0].to_i - 1
        # Check if csv file already existed (imported) in database
        if SourceFile.exists?(file_name: filename)
        	duplicated_files << file
        	puts filename.to_s + ' [Duplicated and ignored]'
        	next
        # For the current stage, we accept importing only 'MI-INDEX' csv files!
        elsif !filename.include? "MI-INDEX"
        	filtered_files << file
        	next
        else # Process the CSV files that we actually need
        	model_stage = '上市公司指數'
        	if post = Post.find_by_title(model_stage)
        		MiReport.import_data(file, filename, post)
        		# Check total imported row counts
        		if file = SourceFile.find_by_file_name(filename)
        			count = MiReport.where(post_id: post, source_file_id: file).count
        			# Check if CSV row numbers equal to record numbers that imported to database
        			if count + 7 == file.total_row
		                imported_files << file
		                puts filename.to_s + ' [successfully imported]'
		            else
		                # If row counts are not equal, rollback all the imported rows
		                file.destroy
		                puts 'Data lost while importing data from ' + filename.to_s
		            end
		        end
        	end
        end
	end
	puts '-' * 50
	puts filtered_csvs.count.to_s + ' CSV file(s) processed, ' + duplicated_files.count.to_s + ' duplicated, ' + no_row_files.count.to_s + ' no-row file(s), and ' + (imported_files.count + imported_main_files.count + imported_mini_files.count).to_s + ' file(s) imported!'
	puts 'Data importing process completed at ' + Time.now.to_s
	end_time = Time.now
	puts "Total time: #{(end_time - start_time)} seconds"
end