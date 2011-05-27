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
  attr_accessible :name, :email

  [:name, :email].each do | sym |
    validates sym, :presence => true, :length => {:maximum => 50 }
  end
  validates :email, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    :uniqueness=> {:case_sensitive => false}
end
