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
end
