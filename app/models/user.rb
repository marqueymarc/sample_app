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

class User < ActiveRecord::Base
    attr_accessor   :password
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
    #not needed, it seems cause of the attr_accessible above.
    validates :password_confirmation, :presence => true

    before_save :encrypt_password
    # get a user if authorized
    def self.authorize(email, password)
	if (u = User.find_by_email(email)) then
	    u = nil if !u.has_password?(password) 
	end
	u
    end
    def has_password?(given_password)
	encrypt(given_password) == self.encrypted_password
    end
    private 
	def encrypt_password
	    if (!self.salt)
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
