class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  default_scope :order => "microposts.created_at DESC"
  scope :from_users_followed_by, lambda { |user|
    followed_by(user)
  }

  validates :content, :presence =>true, :length =>{:maximum => 140, :message =>"over 140 characters"}
  validates :user_id, :presence =>true

  private
  def self.followed_by(user)

    followed_ids = %(select followed_id from Relationships where follower_id = :user_id )
    where(%(user_id in (#{followed_ids}) or user_id = :user_id), :user_id => user.id)
  end

end
