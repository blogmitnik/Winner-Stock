class UserMailer < ApplicationMailer
	default from: 'disneylab987@gmail.com'

	def send_welcome_email(user)
		@user = user
		mail(:to => @user.email, :subject => "Welcome to Winner Stock!")
	end

	def send_default_password_email(full_name, email, password)
		@full_name = full_name
		@email = email
		@password = password
		mail(:to => @email, :subject => "Check Your default password now")
	end
end
