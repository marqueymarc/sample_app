class UsersController < ApplicationController
  def new
    new_title
    @user = User.new
  end

  def show
    @title = "No Users"
    if (@user = User.find(params[:id])) then
	@title = @user.name
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save 
	flash[:success] = "Welcome!"
	sign_in @user
	redirect_to @user
    else
	new_title
	render 'new'
    end
  end
  private
  def new_title
    @title = "Sign Up"
  end

end
