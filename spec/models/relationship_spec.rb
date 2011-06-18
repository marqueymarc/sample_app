require 'spec_helper'

describe Relationship do
  before (:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))
    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @relationship.save!
  end

  it "should have a follower attribute" do
    @relationship.should respond_to(:follower)
  end
  it "should have a followed attribute" do
    @relationship.should respond_to(:followed)
  end
  it "should have the right follower/followed pair" do
    @relationship.followed.should == @followed
    @relationship.follower.should == @follower
  end
  it "destroying the user should destroy the relationship" do
    @followed.destroy
    Relationship.find_by_followed_id(@relationship.id).should be_nil
  end

  describe "validations" do
    it "should require a followed" do
      @relationship.followed = nil
      @relationship.should_not be_valid

    end
    it "should require a follower" do
      @relationship.follower = nil
      @relationship.should_not be_valid

    end

  end
end
