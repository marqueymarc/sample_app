require 'spec_helper'

describe RelationshipsController do
  before(:each) do
    @from = Factory(:user)
    @to = Factory(:user, :email => Factory.next(:email))
    @relationship = @from.relationships.build(:followed_id => @to.id)
    test_sign_in(@from)
  end
  def mk
    xhr :post, :create, :relationship => {:followed_id =>@to.id}
    r = @from.relationships.find_by_followed_id(@to.id)
    r
  end
  def del(r = nil)
   xhr :delete, :destroy,  :id => r.id
  end
  it "should fail if not signed in" do
    test_sign_out
    mk
    response.should redirect_to signin_path
  end
  it "should create a follow relationship" do
    lambda do
       mk
      response.should be_success
    end.should change(Relationship, :count).by(1)
  end
  it "should make from follow to" do
    mk
    @from.following?(@to).should be_true
  end
#  it "should create and go to following page" do
#    mk
#    response.should redirect_to(@to)
#  end
  it "should delete a follow relationship" do
     r = mk
     lambda do
       del r
       response.should be_success

     end.should change(Relationship, :count).by(-1)
  end
end
