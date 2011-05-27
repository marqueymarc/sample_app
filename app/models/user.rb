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

class User < ActiveRecord::Base
    attr_accessor :password
    attr_accessible :name, :email, :password, :password_confirmation

    [:name, :email].each do | sym |
	validates sym, :presence => true, :length => {:maximum => 50 }
    end
    validates :email, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
	:uniqueness=> {:case_sensitive => false}
    validates :password, :presence=> true, 
	:confirmation => true, 
	:allow_blank => false,
	:length => { :within => 6..40, :too_long => "password too long",
	    :too_short => "password must be > 6 characters"}
    before_save :encrypt_password
    private 
	def encrypt_password
	    self.encrypted_password = encrypt(password)
	end
	def encrypt(s)
	    s # for now
	end
end
