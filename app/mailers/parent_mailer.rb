class ParentMailer < ActionMailer::Base
  default from: "amiroutine@gmail.com"
  
  def routines_email(parent, routines_by_child_by_date)
    @routines_by_child_by_date = routines_by_child_by_date
    mail(:to => parent.email, :subject => "Daily Routines")
  end
end
