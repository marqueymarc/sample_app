class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

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
  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end
  def update
    @title = "Edit user"
    @user = User.find(params[:id])

    if (@user && @user.update_attributes(params[:user]))
      flash[:success] = "User updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  private
  def new_title
    @title = "Sign Up"
  end
  def authenticate
    deny_access unless signed_in?
  end
  def correct_user
    redirect_to(root_path) unless current_user?(User.find(params[:id]))
  end

end
