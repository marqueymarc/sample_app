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
      get :new
      response.should be_success
    end
    it "should have the right title" do
	get :new
	response.should have_selector('title', 
	    :content => "| Sign Up")
    end
  end

  describe "POST 'create'" do
    before (:each) do
	@attr = {}
	@attr.default = ""
    end	
    describe "sanity" do
	it "should have the right title" do
	    post :create, :user => @attr
	    response.should have_selector('title', :content => "Sign Up")
	end
    end
	
    describe "failures" do
	it "should not create an empty user" do
	    lambda do 
		post :create, :user => @attr
	    end.should_not change(User, :count)
	end
	it "should re-render the 'new' page" do
	    post :create, :user=> @attr
	    response.should render_template("users/new")
	end
    end
    describe "user entry" do
	before (:each) do
	    pp = "nowandthen"
	    @attr = {:name => "Alice Toklas", 
		:email => "mdeering@mdeering.com",
		:password => pp,
		:password_confirmation => pp}
	end
	it "should create a user" do
	    lambda do 
		post :create, :user => @attr
	    end.should change(User, :count).by(1)
	end
	it "should show that user's page" do
	    post :create, :user=> @attr
	    response.should redirect_to(user_path(assigns(:user)))
	end
	it "should fail if password_confirmation is different" do
	    lambda do 
		@attr[:password_confirmation] = "abcdefg"
		post :create, :user => @attr
	    end.should_not change(User, :count) 
	end
    end

  end
end
