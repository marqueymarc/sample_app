class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def destroy
  end

  def create
    @title = "Sign in"
    h = params[:session]
    user = User.authenticate(h[:email], h[:password])
    if (user.nil?)
	# error
	flash.now[:failure] =  "Invalid email/password combination"
	render 'new'
    else
	# sign and redirect to show page
	sign_in user
	redirect_to user
    end
  end
end
