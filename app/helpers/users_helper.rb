module UsersHelper
	# Add a Gravatar for the profile page:
	def gravatar_for(user, size: 87)
		if user.image?
			image_tag(user.image, alt: user.name, class: "rounded-circle header-profile-img", style: "width: 87px;")
		else
			gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
			gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
			image_tag(gravatar_url, alt: user.name, class: "gravatar")
		end
	 end

	# Add a second version for displaying Gravatars in the main menu. 
	def header_gravatar_for(user, size: 24)
		if user.image?
			# Use social account icon image
			image_tag(user.image, alt: user.name, class: "rounded-circle header-profile-img", style: "width: 24px;")
		else
			# Use gravatar icon image
			gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
			gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
			image_tag(gravatar_url, alt: user.name, class: "rounded-circle header-profile-img")
		end
	end

end