# == Schema Information
#
# Table name: children
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Child < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :user_ids
  
  has_and_belongs_to_many :user
  has_many :routines
  
  def name
    "#{first_name} #{last_name}"
  end
end
