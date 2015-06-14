class User < ActiveRecord::Base
  attr_accessor :remember_token
	# Change email to downcase
	before_save { self.email = email.downcase}

	# Make sure name exists and is less than 50
 	validates :name,  presence: true, length: { maximum: 50 }

 	# Set Email format with REGEX
 	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 	# Make sure email exists, is less than 255, fits VALID_EMAIL_REGEX, and is unique
 	validates :email, presence: true, length: { maximum: 255 },
                  	  format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    # Make sure the password has a minimum length
    validates :password, length: { minimum: 6 }

    def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    												  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
  	end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # def remember
  self.remember_token = User.new_toekn
  update_attribute(:remember_digest, User.digest(remember_token))
end