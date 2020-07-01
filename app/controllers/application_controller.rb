require "securerandom"

class ApplicationController < ActionController::Base
	include UsersHelper

	protect_from_forgery with: :exception
	before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    	def configure_permitted_parameters
        	devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :name, :email, :password)}
        	devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
            devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :name, :email, :password, :password_confirmation, :current_password)}
            devise_parameter_sanitizer.permit(:accept_invitation) { |u| u.permit(:invitation_token, :username, :name, :password, :password_confirmation)}
      	end
end
