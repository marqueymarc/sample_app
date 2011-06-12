class PagesController < ApplicationController
  def home
    @title = "Home"
    if (signed_in?)
      @user = current_user
      @title = @user.name
      @micropost = Micropost.new
    end
  end


  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

  def help
    @title = "Help"
  end
end
