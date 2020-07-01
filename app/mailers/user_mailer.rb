class UserMailer < ApplicationMailer
	default from: 'disneylab987@gmail.com'

	def send_welcome_email(user)
		@user = user
		mail(:to => @user.email, :subject => "Welcome to Winner Stock!")
	end
end
