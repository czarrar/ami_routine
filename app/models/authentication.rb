class Authentication < ActiveRecord::Base
  attr_accessible :oauth_expires_at, :oauth_token, :provider, :uid, :user_id
  belongs_to :user
end
