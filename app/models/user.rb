# == Schema Information
# Schema version: 20110526060700
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'Digest'
USERS_PER_PAGE = 10

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  has_many        :microposts, :inverse_of => :user,
                  :dependent => :destroy

  has_many        :relationships, :foreign_key => "follower_id",
                  :dependent =>:destroy
  has_many        :following, :through => :relationships,
                  :source => :followed

  has_many        :reverse_relationships, :class_name => "Relationship",
                  :foreign_key => "followed_id", :dependent => :destroy

  has_many        :followers,:through => :reverse_relationships,
                  :source => :follower

  [:name, :email].each do |sym|
    validates sym, :presence => true, :length => {:maximum => 50}
  end
  validates :email, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
            :uniqueness=> {:case_sensitive => false}
  validates :password, :presence=> true,
            :confirmation => true,
            :allow_blank => false,
            :length => {:within => 6..40, :too_long => "password too long",
                        :too_short => "password must be > 6 characters"}
  #not needed, it seems cause of the attr_accessible above.
  validates :password_confirmation, :presence => true

  before_save :encrypt_password

  def feed
    Micropost.where("user_id = ?", id)
  end

  # get a user if authorized
  def self.authenticate(email, password)
    if (u = find_by_email(email)) then
      u = nil if !u.has_password?(password)
    end
    u
  end
  def self.authenticate_with_salt(id, salt)
    user = find_by_id(id)
    (user && user.salt == salt)? user: nil
  end

  def has_password?(given_password)
    encrypt(given_password) == self.encrypted_password
  end
  #for will_paginate
  self.per_page = [USERS_PER_PAGE, User.count/20].max

  def following?(user)
    relationships.find_by_followed_id(user)
  end
  def follow!(user)
    relationships.create!(:followed_id =>user.id)
  end
  def unfollow!(user)
    following?(user).destroy
  end

  def uname
    name + (self.admin ? " (admin)": "")
  end

  private
  def encrypt_password
    if (!self.salt) # book says self.new_record? here
      # in case encrypt_password :save is called somewhere else magical
      s = "#{Time.now.to_f}"
      self.salt = secure_hash(s)
    end

    self.encrypted_password = encrypt(password)
  end

  def encrypt(s)
    secure_hash("#{s}&&#{self.salt}")
  end

  def secure_hash(s)
    Digest::SHA2.hexdigest("#{s}")
  end
end
