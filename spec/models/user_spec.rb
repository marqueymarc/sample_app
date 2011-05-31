require 'spec_helper'

describe User do

    def pp(s) 
	{:password => s, :password_confirm => s}
    end

    before(:each) do
	@attr = {:name => @name = "exampleuser", 
	   :email => @email = "ex@user.com",
	   :password => @password = "lemmein", :password_confirm => @password}
	@bad_mails = %w[marc@marc, marc_at_marc.com, marc@marc.]
	@user = User.create!(@attr)
    end
    
    it "should create a new instance given a valid attribute" do
	u = User.create!(@attr.merge(:email=>"next@next.com", :name=>"another"))
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
	    @user.should respond_to(:encrypted_password)
	end
	it "should set the encrypted password" do
	    @user.encrypted_password.should_not be_blank
	end
	it "should match matching encrypted_passwords" do
	    @user.has_password?(@user.password).should be_true
	end
	it "should not match differing encrypted_passwords" do
	    @user.has_password?("other").should be_false
	end
	it "should not match two users with the same password" do
	    u = User.create!(@attr.merge(:email=> "second@email.com"))
	    @user.encrypted_password.should_not == u.encrypted_password
	end
	it "should find an authorized user with a correct password" do
	    User.authorize(@email, @password).should == @user
	end
	it "should not find an user with an incorrect password" do
	    User.authorize(@email, @password + "a").should be_nil
	end
	it "should not find a non-existant user" do
	    User.authorize(@email+"A", @password).should be_nil
	end
    end
end