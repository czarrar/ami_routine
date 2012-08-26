class RoutineReading < ActiveRecord::Base
  attr_accessible :count, :routine_id, :user_id
  
  belongs_to :routine
  belongs_to :user
  
  def increment_page_view
    self.count += 1
    self.save
  end
  
  def increment_page_view!
    self.count += 1
    self.save!
  end
  
  class << self
    def batch_increment_routines(user, routines)
      routines.each do |routine|
        reading = RoutineReading.find_or_create_by_routine_id_and_user_id(
                    :routine_id => routine.id,
                    :user_id => user.id
                  )
        reading.increment_page_view!
      end
    end
  end
end
