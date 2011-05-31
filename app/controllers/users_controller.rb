class UsersController < ApplicationController
  def new
    @title = "Sign Up"
  end

  def show
    @title = "No Users"
    if (@user = User.find(params[:id])) then
	@title = @user.name
    end
  end

end
