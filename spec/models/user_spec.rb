require 'spec_helper'

describe User do
    before(:each) do
	@attr = {:name => "Example A. User", :email => "ex@user.com" }
	@bad_mails = %w[marc@marc, marc_at_marc.com, marc@marc.]
    end
    
    it "should create a new instance given a valid attribute" do
	User.create!(@attr)
    end
    [:name, :email].each do | sym |
      it "should require a #{sym}" do
	no_name_user = User.new(@attr.merge(sym =>""))
	no_name_user.should_not be_valid
      end
    end
    it "should limit long names" do
	lname = "a" * 51
	lname_user = User.new(@attr.merge(:name => lname))
	lname_user.should_not be_valid
    end
    it "should reject ill_formed email names" do 
	@bad_mails.each do |address|
	    b_m = User.new(@attr.merge(:email => address))
	    b_m.should_not be_valid
	end
    end
end
