require 'spec_helper'

describe User do

    def pp(s) 
	{:password => s, :password_confirm => s}
    end

    before(:each) do
	@attr = {:name => "Example A. User", :email => "ex@user.com",
	    :password => "lemmein", :password_confirm => "lemmein"}
	@bad_mails = %w[marc@marc, marc_at_marc.com, marc@marc.]
    end
    
    it "should create a new instance given a valid attribute" do
	u = User.create!(@attr)
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
    it "should reject duplicate emails" do
	User.create!(@attr)
	b_m = User.new(@attr.merge(:email => @attr[:email].upcase))
	b_m.should_not be_valid
    end
    describe "Password validations" do
	[ ["should have a password", ""] ,
	  ["should fail with a password which is too short" , "aaaa"],
	  ["should fail with a password which is too short", "a"*41]
	].each do | pair |
	    it pair[0] do
		b_m = User.new(@attr.merge(pp pair[1]))
		b_m.should_not be_valid
	    end
	end
	it "should have an encrypted_password attribute" do
	    u = User.create(@attr)
	    u.should respond_to(:encrypted_password)
	end
	it "should set the encrypted password" do
	    u = User.create(@attr)
	    u.encrypted_password.should_not be_blank
	end
    end
end
