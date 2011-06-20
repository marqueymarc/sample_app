class RelationshipsController < ApplicationController
   before_filter :authenticate


  def destroy
    u = Relationship.find(params[:id]).followed
    current_user.unfollow!(u)
    redirect_to u
  end

  def create
    u = User.find(params[:relationship][:followed_id])
    current_user.follow!(u)

    redirect_to u

  end
end
