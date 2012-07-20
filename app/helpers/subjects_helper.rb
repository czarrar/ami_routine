module SubjectsHelper
  
  def subjects_for_select
    items = Subject.all.collect { |subject| [subject.name, subject.id] }
    [['Choose one', '']].concat(items)
  end
  
end
