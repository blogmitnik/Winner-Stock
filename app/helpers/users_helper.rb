module UsersHelper
	# Add a Gravatar for the profile page:
		def gravatar_for(user, size: 128)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	 end

	# Add a second version for displaying Gravatars in the main menu. 
	def header_gravatar_for(user, size: 30)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "rounded-circle header-profile-img")
	end

end