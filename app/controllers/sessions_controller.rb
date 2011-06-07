class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def destroy
    # sign out and redirect to sign in page
    sign_out
    redirect_to root_path
  end

  def create
    @title = "Sign in"
    h = params[:session]
    user = User.authenticate(h[:email], h[:password])
    @last_email = h[:email]
    if (user.nil?)
      # error
      flash.now[:failure] = "Invalid email/password combination"
      render 'new'
    else
      # sign and redirect to show page
      sign_in user
      redirect_back_or user
    end
  end
end
