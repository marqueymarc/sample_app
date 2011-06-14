class MicropostsController < ApplicationController
  before_filter :authenticate


  def destroy
    if ((@micropost = Micropost.find_by_id(params[:id])) && belongs(@micropost))
      @micropost.destroy
      flash[:success] = "Deleted."
    else
      flash[:failure] = "Unable to delete"
    end
    @micropost = Micropost.new #for home
    redirect_to root_path
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
    def belongs(m)
       m.user_id == current_user.id
    end
end
