require 'spec_helper'
describe User do

  def pp(s)
    {:password => s, :password_confirmation => s}
  end

  before(:each) do
    @attr = {:name => @name = "exampleuser",
             :email => @email = "ex@user.com",
             :password => @password = "lemmein",
             :password_confirmation => @password}
    @bad_mails = %w[marc@marc, marc_at_marc.com, marc@marc.]
  end

  describe "admin attribute" do
    before (:each) do
      @user = User.create!(@attr)
    end
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    it "should be able to convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end


  it "should create a new instance given a valid attribute" do
    u = User.create!(@attr.merge(:email=>"next@next.com", :name=>"another"))
  end
  it "should fail if password and confirmation don't match" do
    u = User.new(@attr.merge(:password_confirmation => "xx"))
    u.should_not be_valid
  end
  [:name, :email].each do |sym|
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
    before(:each) do
      @user = User.create!(@attr)
    end

    [["should have a password", ""],
     ["should fail with a password which is too short", "aaaa"],
     ["should fail with a password which is too long", "a"*41]
    ].each do |pair|
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
    it "should find an authenticated user with a correct password" do
      User.authenticate(@email, @password).should == @user
    end
    it "should not find an user with an incorrect password" do
      User.authenticate(@email, @password + "a").should be_nil
    end
    it "should not find a non-existant user" do
      User.authenticate(@email+"A", @password).should be_nil
    end
  end
end
