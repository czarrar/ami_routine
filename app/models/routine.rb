# == Schema Information
#
# Table name: routines
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  starts_at   :datetime
#  ends_at     :datetime
#  all_day     :boolean
#  subject_id  :integer
#  published   :boolean
#

class Routine < ActiveRecord::Base
  attr_accessible :child_ids, :subject_id, :starts_at, :ends_at, :all_day, :description, :published
  
  before_save :default_values
  
  belongs_to :user
  belongs_to :subject
  has_and_belongs_to_many :children
  
  scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Routine.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Routine.format_date(start_time)] }}
  scope :for_parent, lambda {|user| joins(:children => :user).where("users.id = ?", user.id) }
  scope :range_for_day, lambda {|day| {:conditions => ["starts_at >= :start AND ends_at < :end", 
                                                      { :start => day, :end => day + 1.day }] }}
  scope :published?, where(:published => true)
  
  validates :user_id, :presence => true
  validates :starts_at, :presence => true
  validates :subject_id, :presence => true
  validates :child_ids, :presence => true
  
  def default_values
    self.all_day ||= false
    self.published ||= false
    return true
  end
  
  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => self.subject.name,
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
    if starts_at.is_a? String
      self[:starts_at] = Time.parse(starts_at).utc
    elsif starts_at.is_a? Time
      self[:starts_at] = starts_at.utc
    else
      raise 'starts_at unrecognized class #{starts_at.class}'
    end
  end
  
  def starts_at
    Time.at(self[:starts_at]) if !self[:starts_at].nil?
  end
  
  def utc_starts_at
    self[:starts_at]
  end
  
  def ends_at=(ends_at)
    if ends_at.is_a? String
      self[:ends_at] = Time.parse(ends_at).utc
    elsif ends_at.is_a? Time
      self[:ends_at] = ends_at.utc
    else
      raise 'ends_at unrecognized class #{ends_at.class}'
    end
  end
  
  def ends_at
    Time.at(self[:ends_at]) if !self[:ends_at].nil?
  end
  
  def utc_starts_at
    self[:ends_at]
  end
  
end
