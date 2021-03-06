require 'spec_helper'
describe User do

  def pp(s)
    {:password => s, :password_confirmation => s}
  end

  before(:each) do
    @attr = {:name => @name = "exampleuser",
             :email => @email = "ex@auser.com",
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

  describe "User creation" do
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
  describe "micropost associations" do
    before (:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user=>@user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user =>@user, :created_at => 1.hour.ago)

    end
    it "should respond to microposts" do
      @user.should respond_to(:microposts)
    end
    it "should respond microposts in rev chron order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    it "should destroy microposts belonging to destroyed users" do
      @user.destroy
      Micropost.find_by_user_id(@user.id).should be_nil
    end

    describe "status feeds" do
      it "should respond to feed" do
        @user.should respond_to(:feed)
      end
      it "should include posts by the user" do
        @user.feed.should include @mp1
        @user.feed.should include @mp2
      end
      it "should not include posts by a different user" do
        mp3 = Factory(:micropost, :content => "another",
                      :user =>Factory(:user,
                                      :email=> Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
      it "should include posts from a followed user" do
        mp3 = Factory(:micropost, :content => "another",
                      :user =>Factory(:user,
                                      :email=> Factory.next(:email)))
        @user.follow!(mp3.user)
        @user.feed.should include(mp3)
      end
    end
  end
  describe "relationship association" do
    before (:each) do
      @user = User.create(@attr)
      @followed = Factory(:user)
    end
    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end
    it "should respond to following" do
      @user.should respond_to(:following)

    end
    it "should respond to followers" do
      @user.should respond_to(:followers)
    end
    it "should have a following? method" do
      @user.should respond_to(:following?)
    end
    it "should have a follow! method" do
      @user.should respond_to (:follow!)
    end
    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end
    it "should include the user in the followed array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)

    end
    it "should unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)

    end
    it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end
    it "should have a followers method" do
      @user.should respond_to(:followers)
    end
    it "should include followers in the array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
  end
end

