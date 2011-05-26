require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    @a = %w[/ /contact /about /help /signup]
    @b = %w[Home Contact About Help Sign\ Up]
    @a.zip(@b).each do |url, name| 
      it "should have a #{name} page at #{url}" do
	  get url
	  response.should have_selector('title', :content => name)
      end
    end
  end
#  describe "more layout links" do
#    it "should have the right links on the layout" do
#        visit root_path
#        click_link "About"
#        response.should have_selector('title', :content => "About")
#        click_link "Help"
#        response.should have_selector('title', :content => "Help")
#        click_link "Contact"
#        response.should have_selector('title', :content => "Contact")
#	visit root_path
#        click_link "Home"
#        response.should have_selector('title', :content => "Home")
#        click_link "Sign up now!"
#        response.should have_selector('title', :content => "Sign up")
#     end
#   end
end
