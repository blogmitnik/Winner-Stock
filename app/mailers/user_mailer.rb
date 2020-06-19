class UserMailer < ApplicationMailer
	default from: 'admin@winner-stock.com'

	def send_welcome_email(user)
		@user = user
		mail(:to => @user.email, :subject => "Welcome to Winner Stock!")
	end
end
