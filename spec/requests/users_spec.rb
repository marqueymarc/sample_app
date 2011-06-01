require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
	it "should not make a new user when empty" do
	    lambda do
		visit signup_path
		fill_in "Name", :with => "b"
		fill_in "Email", :with => ""
		fill_in "Password", :with=>  ""
		fill_in "Password Confirmation", :with=>  ""
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
		fill_in "Password", :with=>  "123456"
		fill_in "Password Confirmation", :with=>  "123456"
		click_button
		response.should render_template("users/show")
		response.should have_selector(".flash.success", :content => "Welcome")
	    end.should change(User, :count).by(1)
	end
    end
  end

#  describe "GET /users" do
#    it "works! (now write some real specs)" do
#      visit users_index_path
#      response.status.should be(200)
#    end
#  end
end
