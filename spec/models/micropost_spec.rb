require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = {
        :content => "value for content"
    }
    @micropost = @user.microposts.create(@attr)
  end

  it "should create a valid post" do
    @user.microposts.create!(@attr)
  end
  it "should respond to the user attr" do
    @micropost.should respond_to(:user)
  end
  it "user should be the same as the i" do
    @micropost.user.should == @user
    @micropost.user_id.should == @user.id
  end
  it "content should be <= 140 chars" do
    @user.microposts.build({:content =>"a"*141}).should_not be_valid

  end
  it "should have a valid user_id" do
    Micropost.new(@attr).should_not be_valid
  end
  it "should have non-blank content" do
    @user.microposts.build({:content =>"  "}).should_not be_valid

  end
  it "Microposts should have a from_users_followed_by method" do
    Micropost.should respond_to(:from_users_followed_by)
  end

  describe "integrated feed" do
    before (:each) do
      @user2 = Factory(:user, :email=> Factory.next(:email))
      @user3 = Factory(:user, :email=> Factory.next(:email))
      @user4 = Factory(:user, :email=> Factory.next(:email))

      @user.follow!(@user2)
      @user.follow!(@user3)
      @user2.follow!(@user4)
      [@user, @user2, @user3, @user4].each do |u|
        u.microposts.create!(@attr)
      end
      @mps = Micropost.from_users_followed_by(@user)

    end

    it "should include posts from  followed users" do
      [@user, @user2, @user3].each do |u|
        @mps.should include(u.microposts.first)
      end
    end
    it "should not include posts from not followed user" do
      @mps.should_not include(@user4.microposts.first)
    end

  end
end

