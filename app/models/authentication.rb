class Authentication < ActiveRecord::Base
  attr_accessible :oauth_expires_at, :oauth_token, :provider, :uid, :user_id
  belongs_to :user
end
# == Schema Information
#
# Table name: authentications
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  provider         :string(255)
#  uid              :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

