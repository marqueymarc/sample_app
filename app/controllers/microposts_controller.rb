class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :belongs, :only=>[:destroy]


  def destroy
    if (@micropost = Micropost.find(params[:id]))
      @micropost.destroy
    end
    flash.now[:success] = "Deleted."
    render 'pages/home'
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Posted!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end
  private
    def belongs
       redirect_to root_path unless @micropost.user_id == current_user.id
    end
end
