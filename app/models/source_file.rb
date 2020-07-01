class SourceFile < ApplicationRecord
	#attr_accessible :post_id, :file_name, :total_row, :published_at

	belongs_to :post
	has_many :reports, dependent: :destroy
	has_many :mi_reports, dependent: :destroy
	has_many :categories

	validates :file_name, presence: true, uniqueness: true
	validates :post_id, :total_row, :published_at, presence: true
	validates :total_row, numericality: { only_integer: true }

	before_create do
		file_extension = File.extname(self.file_name)
		if !file_extension.downcase == '.csv'
		  false
		end
	end

	after_create do
		# If failed to import reports, delete the yield file from database 
		unless Report.where('source_file_id = ?', self.id).first.equal? nil
		  self.destroy
		end
	end

	before_validation :set_uuid, on: :create

	def set_uuid
		self.id = SecureRandom.uuid
	end
end
