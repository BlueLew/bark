# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
	def new_review_email
    UserMailer.new_review_email
  end
end
