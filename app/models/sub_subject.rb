# == Schema Information
#
# Table name: sub_subjects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  subject_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class SubSubject < ActiveRecord::Base
  attr_accessible :name, :subject_id
end

