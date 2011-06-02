module SessionsHelper

    def sign_in(user)
	cookies.permanent.signed[:remember_token] = a = [user.id, user.salt]
	self.current_user = user
	p "sign_in:", a.inspect
    end
    def signed_in?
	current_user == @current_user
    end
    def current_user
	#@current_user ||= user_from_remember_token
	@current_user = user_from_remember_token
    end
    def current_user=(user)
	@current_user = user
    end
private
    def user_from_remember_token
	User.authenticate_with_salt(*remember_token)
    end

    def remember_token
	cookies.signed[:remember_token] || [nil, nil]
    end
end
