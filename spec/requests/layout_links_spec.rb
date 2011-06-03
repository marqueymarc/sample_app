require 'spec_helper'


describe "LayoutLinks" do
  describe "GET /layout_links" do
    @a = %w[/contact /about /help / /signup]
    @b = %w[Contact About Help Home Sign\ Up]
    @a.zip(@b).each do |url, name| 
      it "should have a #{name} page at #{url}" do
	  get url
	  response.should have_selector('title', :content => name)
      end
      it "should have a #{name} link in the layout" do
	visit root_path
	click_link name
	response.should have_selector('title', :content => name)
      end
    end
  end
  describe "not signed in" do
    it "should have a signin link when not signed in" do
	visit root_path
	response.should have_selector('a', :href => signin_path, 
		    :content => "Sign in")
    end
   end
   describe "Signed in" do
	before (:each) do
	    @user = Factory(:user)
	    visit signin_path
	    fill_in :email, :with => @user.email
	    fill_in :password, :with => @user.password
	    click_button
	end
	it "should have a signout link when signed in" do
	    visit root_path
	    response.should have_selector('a', :href => signout_path, 
			:content => "Sign out")
	end
	it "should have a profile link" do
	    visit root_path
	    response.should have_selector('a', :content => "Profile", :href => user_path(@user))
	end
    end
end
