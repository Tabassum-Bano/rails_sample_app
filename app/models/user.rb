class User < ApplicationRecord

	attr_accessor :remember_token, :activation_token

	before_create :create_activation_digest
	before_save {email.downcase!}
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email,presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum: 6}, allow_nil: true

	has_secure_password

	#hash digest for the given string

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	#random token for storing in cookies
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	#remembers a user in database for use in in persistent session
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	#returns true if the token matches the digest
	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	#forgets user by removing remember digest
	def forget
		update_attribute(:remember_digest, nil)
	end

	private

	#activation token addition to object
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

	#activates an account
	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
		#update_attribute(:activated, true)
		#update_attribute(:activated_at, Time.zone.now)
	end

	#sends activation email
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

end
