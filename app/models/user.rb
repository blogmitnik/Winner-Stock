class User < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: :slugged

	self.implicit_order_column = "created_at"

  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  	devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, 
  		:trackable

	# Add some password complexity requirements
	validate :password_complexity

	def password_complexity
		if password.present? and not password.match(/\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/)
			errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
		end
	end

	# Add validations for the username and full name length
	validates :name, :username, presence: true, length: { minimum: 2, maximum: 25 }
	validates_uniqueness_of :username, :email, case_sensitive: false

	after_create :send_admin_mail

	def send_admin_mail
		UserMailer.send_welcome_email(self).deliver_later
	end
end
