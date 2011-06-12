require 'spec_helper'

describe MicropostsController do
  render_views
  before (:each) do
    @user = Factory(:user)
    @attr = {:content =>"any"}
  end

  def invalid_op_response
    response.should redirect_to(signin_path)
  end

  def delete_mp(id = nil)
    delete :destroy, :id => (id ? id.id : 1)
  end

  def create_mp
    post :create, :micropost=>@attr
    (@user && @user.microposts) ? @user.microposts.first: nil
  end


  describe 'POST create' do

    describe "failures" do
      it "should not allow create for unsigned in users" do
        lambda do
          create_mp
        end.should_not change(Micropost, :count)
      end

      it "should go back to signin page" do
        create_mp
        invalid_op_response
      end
    end
    describe "successes" do
      before (:each) do
        test_sign_in(@user)
        @attr = {:content => "Lorem"}
      end
      it "should create an additional mp" do
        lambda do
          create_mp
        end.should change(Micropost, :count).by(1)
      end
      it "should redirect to home page" do
        create_mp
        response.should redirect_to root_path
      end
      it "should have a flash message" do
        create_mp
        flash[:success].should =~ /posted/i
      end
    end


  end
  describe 'DELETE destroy' do


    before (:each) do
      test_sign_in(@user)
      @mp = create_mp
      test_sign_out
    end


    it "should not allow destroy for non-signed in user" do
      lambda do
        delete_mp @mp
      end.should_not change(Micropost, :count)
    end
    it "should not allow destroy for non-owning user" do
      auser = Factory(:user, :email => "x@x.com")
      test_sign_in(auser)
      lambda do
        delete_mp @mp
      end.should_not change(Micropost, :count)
    end
    describe "success" do
      before(:each) do
        test_sign_in(@user)


      end
#     it "should allow destroy for owning user w/ message" do
#        test_sign_in(@user)
#        delete_mp @mp
#        response.should have_selector('.flash', :content => "eleted")
#      end
    end

  end
end

