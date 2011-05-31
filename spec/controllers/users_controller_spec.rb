require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before (:each) do
	@user = Factory(:user)
	get :show, :id => @user
    end
    it "should be successful" do
	response.should be_success
    end
    it "should find the right user" do
	# user in the controller should be the one we created here.
	assigns(:user).should == @user
    end
    it "should have the name of the user as the title" do
	response.should have_selector('title', :content => @user.name)
    end
    it "should have the user's name in it" do
	response.should have_selector('name', :content => @user.name)
    end
    it "should have a gravatar image in it" do
	response.should have_selector('name>img', :class=> 'gravatar')
    end
  end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have the right title" do
	get 'new'
	response.should have_selector('title', 
	    :content => "| Sign Up")
    end
  end

end
