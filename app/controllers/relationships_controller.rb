class RelationshipsController < ApplicationController
   before_filter :authenticate


  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond
  end

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond
  end
  private
  def respond
    respond_to do |format|
      format.html {redirect_to @user}
      format.js {render :template => 'relationships/change_follow.js.erb'}
    end

  end
end
