# == Schema Information
#
# Table name: children
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  album_id   :integer
#  album_key  :string(255)
#

class Child < ActiveRecord::Base
  attr_accessor :album
  attr_accessible :first_name, :last_name, :user_ids, :album, :album_id, :child_users_attributes
  
  has_and_belongs_to_many :routines
  
  has_many :child_users
  has_many :users, :through => :child_users
  accepts_nested_attributes_for :child_users, 
                                reject_if: proc { |attributes| attributes['user_id'].blank? },
                                allow_destroy: true
  
  #before_save :albumize
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  #validates :user_ids, :presence => true
  
  def albumize
    if album.present?
      elems = album.split(" ")
      self.album_id = elems[0].to_i
      self.album_key = elems[1]
    end
    return true
  end
  
  def name
    "#{first_name} #{last_name}"
  end
end
