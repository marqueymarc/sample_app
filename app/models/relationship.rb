class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name =>"User"

  [:followed_id, :follower_id].each do |s|
    validates s, :presence => true


  end
end
