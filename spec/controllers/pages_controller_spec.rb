require 'spec_helper'

describe PagesController do
  render_views


  describe "GET 'home'" do

    it "should be successful" do
      get 'home'
      response.should be_success
      end
    describe "when not signed in" do
      before (:each) do
        get :home
      end
      it "should have the right title" do
        response.should have_selector('title',
                                      :content=> "| Home")
      end
    end
    describe "when signed in" do
      before (:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        user2 = Factory(:user, :email =>Factory.next(:email))
        user2.follow!(@user)
        get :home
      end
      it "follower should have following 0,  follower 1" do
        response.should have_selector('a', :href => following_user_path(@user),
                                     :content => "0 following")
        response.should have_selector('a', :href => followers_user_path(@user),
                                     :content => "1 follower")
      end
    end

  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get "about"
      response.should have_selector('title',
                                    :content=> "| About")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get "contact"
      response.should have_selector('title',
                                    :content=> "| Contact")
    end
  end

end
