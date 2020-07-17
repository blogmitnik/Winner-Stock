class Post < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged

	has_many :reports, dependent: :destroy
  	has_many :mi_reports, dependent: :destroy
  	has_many :source_files, dependent: :destroy
  	has_many :categories, dependent: :destroy
  	has_many :companies, dependent: :destroy

	validates :title, presence: true, length: { :minimum => 3, :maximum => 255 }
	validates :slug, presence: true

	before_validation :set_uuid, on: :create

	def set_uuid
		self.id = SecureRandom.uuid
	end
end
