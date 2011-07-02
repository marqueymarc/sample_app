require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user when empty" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "b"
          fill_in "Email", :with => ""
          fill_in "Password", :with=> ""
          fill_in "Password Confirmation", :with=> ""
          click_button
          response.should render_template("users/new")
          response.should have_selector("#error_explanation")
        end.should_not change(User, :count)
      end
    end
    describe "success" do
      it "should make a new user when valid" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "Marc"
          fill_in "Email", :with => "marc@persefon.com"
          fill_in "Password", :with=> "123456"
          fill_in "Password Confirmation", :with=> "123456"
          click_button
          response.should render_template("users/show")
          response.should have_selector(".flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do
    describe "failure" do
      it "should not sign an invalid user in" do
        user = Factory(:user)
        user.password += "a"
        integration_sign_in(user)
        response.should have_selector('.flash.failure',
                                      :content => "Invalid")
      end
    end
    describe "success" do
      it "should sign in and out a valid user" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
  describe "delete" do
    before (:each) do
	@user2 = Factory(:user, :name => "Delete Thisone", 
	    :email => Factory.next(:email))
	@user = Factory(:user)
	@user.toggle!(:admin)
	integration_sign_in(@user)
	visit users_path
    end

    it "should go to list of users" do
	click_link  "Delete Delete Thisone"
	response.should render_template("users")
    end
    it "should delete a user" do
	response.body.should =~ /Delete Thisone/
	click_link  "Delete Delete Thisone"
	response.body.should_not =~ /Delete Thisone/
    end
  end
end
