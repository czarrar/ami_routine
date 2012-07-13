# == Schema Information
#
# Table name: routines
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  child_id     :integer
#  content      :text
#  routine_date :date
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Routine < ActiveRecord::Base
  attr_accessible :child_id, :content, :routine_date
  
  belongs_to :user
end
