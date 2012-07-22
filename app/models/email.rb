class Email
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :starts_at, :ends_at, :parent_ids
 
  validates :starts_at, :presence => true, 
                        :format => { :with => /\d{2}\/\d{2}\/\d{4}/ }
  validates :ends_at, :presence => true, 
                      :format => { :with => /\d{2}\/\d{2}\/\d{4}/ }
  validates :parent_ids, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
end