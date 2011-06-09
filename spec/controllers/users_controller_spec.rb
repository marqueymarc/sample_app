require 'spec_helper'

describe UsersController do
  render_views

  describe "GET'index'" do
    it "should deny access to non-signed in users" do
      get :index
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end
    describe "signed-in users" do
      before (:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        user2 = Factory(:user, :email => "an@an.com", :name =>"Ann Other")
        user3 = Factory(:user, :email => "An@omyn.com", :name => "Ang Onymous")
        @users = [@user, user2, user3]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
        get :index
      end

      it "should have the right title" do
        response.should have_selector('title', :content =>"All users")
      end
      it "should show users" do

        @users.each do |u|
          response.should have_selector('li', :content =>u.name)
        end
      end
      it "should not show delete links to non-admins" do
        response.should_not have_selector('li', :content =>"delete")
      end
      it "should show delete links to admins" do
        @user.toggle!(:admin)
        get :index
        response.should have_selector('li', :content =>"delete")
      end
      it "should be successful" do
        response.should be_success
      end
      it "should paginate users" do
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                      :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                      :content => "Next")
      end
    end
  end
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
      it "should show show a welcome message" do
        post :create, :user=> @attr
        flash[:success].should =~ /Welcome/i
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
      it "should sign in a new user" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end

  end
  describe "GET 'edit'" do
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      get :edit, :id => @user
    end

    it "should be successful" do
      response.should be_success
    end


    it "should have the right title" do
      response.should have_selector('title', :content => "Edit user")

    end
    it "should have a link to change the Gravatar" do
      gravatar_email = "http://gravatar.com/emails"
      response.should have_selector('a', :href => gravatar_email)

    end
  end
  describe "PUT update" do
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    describe "failure" do
      before(:each) do
        @attr = {:email => "", :name => "", :password => "",
                 :password_confirmation => ""}
      end
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end
    describe "success" do
      before(:each) do
        pp = "123456a"

        @attr = {:name => "New Name", :email => "user@example.org",
                 :password => "barbaz", :password_confirmation => "barbaz"}
        @attr = {:email =>"newEmail@email.com", :password => pp, :name =>"Alias E. Male",
                 :password_confirmation => pp}
      end
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
      describe "failure" do
        before (:each) do
          @attr = {:email =>"", :password => "", :name =>""}
          put :update, :id=>@user, :user => @attr
        end
        it "should return to edit" do
          response.should render_template("edit")
        end
        it "should have edit in the title" do
          response.should have_selector('title', :content => "Edit user")
        end
      end
      describe "success" do
        before (:each) do
          pp = "123456a"
          @attr = {:email =>"newEmail@email.com", :password => pp, :name =>"Alias E. Male",
                   :password_confirmation => pp}
          put :update, :id=>@user, :user => @attr
        end
        it "should change the attributes" do
          @user.reload
          [:name, :email].each do |a|
            @user[a].should == @attr[a]
          end
        end
        it "should inform of success" do
          flash[:success].should =~ /updated/
        end
        it "should go to the show page for this user" do
          response.should redirect_to(user_path(@user))
        end
      end
    end
  end
  describe "edit/update " do
    before (:each) do
      @user = Factory(:user)
    end
    describe "not signed in" do
      it "should not be possible to issue an edit w/o being signed in" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      it "should not be possible to issue an update w/o being signed in" do
        put :update, :id=>@user, :user=>@user
        response.should redirect_to(signin_path)
      end
    end
    describe "signed in" do
      before(:each) do
        @baduser = Factory(:user, :email => "bad@bad.com")
        test_sign_in(@user)
      end
      it "should not allow a user to edit another user's info" do
        get :edit, :id =>@baduser
        response.should redirect_to(root_path)
      end
      it "should not allow a user to update another user's info" do
        put :update, :id =>@baduser, :user => @baduser
        response.should redirect_to(root_path)
      end
    end
  end
  describe "DELETE 'destroy'" do
    before (:each) do
      @user = Factory(:user)
    end
    describe "as a non signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    describe "as a signed-in user" do
      before (:each) do
        @admin = Factory(:user, :email =>"admin@admin.com")
        test_sign_in(@admin)
      end
      it "should not allow a non-admin to delete" do
        delete :destroy, :id =>@user
        response.should redirect_to(root_path)
      end
      describe "deletes if admin" do
        before (:each) do
          @admin.toggle!(:admin)
        end

        it "should allow delete if admin" do
          lambda do
            delete :destroy, :id=>@user
          end.should change(User, :count).by(-1)
        end
        it "should not allow delete of yourself" do
           lambda do
             delete :destroy, :id=>@admin
           end.should_not change(User, :count)
           flash[:failure].should =~ /can't/i
        end
      end
    end
  end
end
