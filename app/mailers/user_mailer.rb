class UserMailer < ApplicationMailer
	def new_review_email(user)
		@user = user
	
		mail(to: @user.email, subject: 'New restaurant review!')
	end
end
