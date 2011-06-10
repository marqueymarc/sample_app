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
end

