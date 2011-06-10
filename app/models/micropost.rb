class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to    :user
  default_scope :order => "microposts.created_at DESC"

  validates   :content, :presence =>true, :length =>{:maximum => 140, :message =>"over 140 characters"}
  validates   :user_id, :presence =>true

end
