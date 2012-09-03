# == Schema Information
#
# Table name: routine_templates
#
#  id             :integer         not null, primary key
#  sub_subject_id :integer
#  name           :string(255)
#  description    :text
#  notes          :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class RoutineTemplate < ActiveRecord::Base
  attr_accessible :description, :name, :notes, :sub_subject_id
end
