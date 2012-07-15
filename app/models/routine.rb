# == Schema Information
#
# Table name: routines
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  child_id    :integer
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  title       :string(255)
#  starts_at   :datetime
#  ends_at     :datetime
#  all_day     :boolean
#

class Routine < ActiveRecord::Base
  attr_accessible :child_id, :title, :starts_at, :ends_at, :all_day, :description
  
  belongs_to :user
  belongs_to :child
  
  scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Routine.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Routine.format_date(start_time)] }}
  
  # todo: add validations
  
  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :description => self.description || "",
      :start => starts_at.rfc822,
      :end => ends_at.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.routine_path(id)
    }
  end
  
  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
  
  ###
  # Wrap starts_at and ends_at
  # so that output is local-time
  # but saving is done in UTC
  ###
  
  def starts_at=(starts_at)
    self[:starts_at] = Time.parse(starts_at).utc
  end
  
  def starts_at
    Time.at(self[:starts_at])
  end
  
  def utc_starts_at
    self[:starts_at]
  end
  
  def ends_at=(ends_at)
    self[:ends_at] = Time.parse(ends_at).utc
  end
  
  def ends_at
    Time.at(self[:ends_at])
  end
  
  def utc_starts_at
    self[:ends_at]
  end
  
end
