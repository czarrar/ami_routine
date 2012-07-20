module ApplicationHelper
  def daily_routine_path
    if user_signed_in?
      if current_user.has_role? :teacher 
        teacher_calendar_path
      elsif current_user.has_role? :parent
        parent_calendar_path
      end
    else
      '#'
    end
  end
end
