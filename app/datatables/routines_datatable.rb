class RoutinesDatatable
  delegate :params, :h, :raw, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Routine.count,
      iTotalDisplayRecords: routines.total_entries,
      aaData: data
    }
  end

private

  def data
    routines.collect do |routine|
      d = [
        routine.user.name,
        routine.children.collect { |child| child.name }.join(", "),
        routine.starts_at, 
        routine.ends_at, 
        routine.all_day, 
        routine.subject.name, 
        raw(routine.description)
      ]
      
      if @view.current_user.has_role? :teacher
        links = ""
        links += link_to 'Edit', @view.edit_routine_path(routine), :class => "btn btn-mini"
        links += link_to 'Delete', routine, :confirm => "Are you sure?", :method => :delete, :class => 'btn btn-mini btn-danger'
        d << links
      end
      
      d
    end
  end

  def routines
    @routines ||= fetch_routines
  end

  def fetch_routines
    routines = Routine.includes(:user, :children, :subject).order("#{sort_column} #{sort_direction}")
    routines = routines.page(page).per_page(per_page)
    if params[:sSearch].present?
      routines = routines.where("users.first_name LIKE :search OR users.last_name LIKE :search OR children.first_name LIKE :search OR children.last_name LIKE :search OR starts_at LIKE :search OR ends_at LIKE :search OR subjects.name LIKE :search OR description LIKE :search", search: "%#{params[:sSearch]}%")
    end
    routines
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[users.first_name starts_at ends_at all_day subjects.name description]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
