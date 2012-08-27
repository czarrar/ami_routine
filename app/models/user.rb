# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  first_name             :string(255)
#  last_name              :string(255)
#  phone_home             :string(255)
#  phone_work             :string(255)
#  phone_mobile           :string(255)
#  address_home           :string(255)
#  city_home              :string(255)
#  zip_home               :string(255)
#  notes                  :text
#

class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable, :registerable
  devise :database_authenticatable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :first_name, :last_name, 
                  :phone_home, :phone_work, :phone_mobile, 
                  :address_home, :city_home, :zip_home, 
                  :notes, 
                  :role_ids, :child_ids
  
  validates :email, :presence => true, 
                    :uniqueness => { :case_sensitive => false }, 
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  
  validates :zip_home, :allow_blank => true,
                       :length => { :is => 5 }
  
  has_many :routines
  has_many :authentications
  has_and_belongs_to_many :roles, :join_table => :users_roles
  has_many :routine_readings
  
  has_many :child_users
  has_many :children, :through => :child_users
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def link_to_omniauth(auth)
    self.authentications.create(
      provider:         auth.provider, 
      uid:              auth.uid,
      oauth_token:      auth.credentials.token,
      oauth_expires_at: Time.at(auth.credentials.expires_at)
    )
  end
  
  class << self
  
    def from_omniauth_find_or_create(auth)
      user = find :first, :joins => :authentications, 
                  :conditions => { :authentications => auth.slice(:provider, :uid) }, 
                  :readonly => false
      user = from_omniauth_create(auth) if user.nil?
      return user    
    end
  
    def from_omniauth_create(auth)
      user = where("email = :email OR (first_name = :first_name AND last_name = :last_name)", 
                    auth.info.slice(:email, :first_name, :last_name)).first
      user.link_to_omniauth(auth) if user.present?
      return user
    end
    
  end
end

