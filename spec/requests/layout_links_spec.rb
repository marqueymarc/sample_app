require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    @a = %w[/ /contact /about /help]
    @b = %w[Home Contact About Help]
    @a.zip(@b).each do |url, name| 
      it "should have a #{name} page at #{url}" do
	  get url
	  response.should have_selector('title', :content => name)
      end
    end
  end
end
