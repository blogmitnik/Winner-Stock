class Post < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged

	validates :title, presence: true, length: { :minimum => 3, :maximum => 255 }
	validates :slug, presence: true

	before_validation :set_uuid, on: :create

	def set_uuid
		self.id = SecureRandom.uuid
	end
end
