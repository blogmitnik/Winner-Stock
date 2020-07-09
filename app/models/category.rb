class Category < ApplicationRecord
	#attr_accessible :post_id, :source_file_id, :name, :slug

	belongs_to :post
	has_many :reports, dependent: :destroy
	has_many :mi_reports, dependent: :destroy

	validates :name, :post_id, presence: true

	before_validation :set_uuid, on: :create

	def set_uuid
		self.id = SecureRandom.uuid
	end
end
