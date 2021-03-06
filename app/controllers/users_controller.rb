class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy,
                        :following, :followers]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_only, :only => [:destroy]

  def index

    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end


  def new
    new_title
    @user = User.new
  end

  def show
    @title = "No Users"
    @microposts = nil
    if (@user = User.find(params[:id])) then
      @title = @user.name
      @microposts = @user.microposts.paginate(:page => params[:page])
    end
  end


  def destroy
    del_user = User.find(params[:id])

    if (del_user == current_user)
      flash[:failure] = "You can't delete yourself!"
    else
      flash[:success] = "Deleted #{del_user.name}"
      del_user.destroy
    end
    redirect_to users_path
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = "Welcome!"
      sign_in @user
      redirect_to @user
    else
      new_title
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
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

  def following
    @user = User.find(params[:id])
    @verbs = ["Following", "Follows"]
    @title = "#{@user.name.titlecase} Following"
    @users = @user.following.paginate(:page => params[:page])
    @no_del = true
    render 'show_follow'

  end

  def followers
    @user = User.find(params[:id])
    @verbs = ["Followers", "Followed by"]
    @title = "#{@user.name.titlecase}'s Followers"
    @users = @user.followers.paginate(:page => params[:page])
    @no_del = true
    render 'show_follow'


  end

  private
  def new_title
    @title = "Sign Up"
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_only
    redirect_to(root_path) unless current_user.admin?
  end

end