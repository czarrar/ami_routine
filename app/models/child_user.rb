# == Schema Information
#
# Table name: child_users
#
#  child_id     :integer
#  user_id      :integer
#  relationship :string(255)
#

class ChildUser < ActiveRecord::Base
  attr_accessible :child_id, :user_id, :relationship
  
  validates_uniqueness_of :child_id, scope: :user_id
  
  belongs_to :child
  belongs_to :user
end
