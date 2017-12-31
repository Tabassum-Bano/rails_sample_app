module SessionsHelper
	#logs in given user
	def log_in(user)
		session[:user_id]=user.id
	end

	#remembers a user in persistent session
	def remember(user)
		user.remember
		cookies.permanent[:remember_token]=user.remember_token
		cookies.permanent.signed[:user_id]=user.id
	end

	def current_user
		if(user_id = session[:user_id])
			@current_user = @current_user || User.find_by( id: user_id)
		elsif(user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end
	#forgets a persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user=nil
	end

	def logged_in?
		!current_user.nil?
	end

end
