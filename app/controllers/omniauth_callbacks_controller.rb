class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	skip_before_action :authenticate_user!

	# Sign in with Google account
	def google_oauth2
		@user = User.from_omniauth(request.env['omniauth.auth'])

		if @user.persisted?
			flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
			sign_in_and_redirect @user, event: :authentication
		else
			session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
			flash[:alert] = I18n.t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{request.env['omniauth.auth'].info.email} is not authorized."
			redirect_to new_registration_url(resource), alert: @user.errors.full_messages.join("\n")
		end
  	end

  	# Sign in with Facebook account
	def facebook
		@user = User.from_omniauth(request.env["omniauth.auth"])

		if @user.persisted?
			flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Facebook'
			sign_in_and_redirect @user, :event => :authentication
		else
			if @user.email.nil?
				# Delete error session to prevent registration fail (by using Koala gem)
				@user.delete_access_token(request.env["omniauth.auth"])
				redirect_to new_registration_url(resource), alert: "Please authorize to access your facebook account info!"
			else
				session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
				flash[:alert] = I18n.t 'devise.omniauth_callbacks.failure', kind: 'Facebook', reason: "#{request.env['omniauth.auth'].info.email} is not authorized."
				redirect_to new_registration_url(resource), alert: @user.errors.full_messages.join("\n")
			end
		end
	end

	def failure
		redirect_to root_path, alert: "Unable to authenticate user!"
	end
end
