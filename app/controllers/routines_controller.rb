class RoutinesController < ApplicationController
  before_filter :authenticate_user!
  
  before_filter :teacher_only, :only => ["new", "create", "edit", "update", "destroy"]  
  
  ###
  # CRUD
  ###
  
  def index    
    @routines = Routine.scoped
    @routines = @routines.after(params[:start]) if params[:start]
    @routines = @routines.before(params[:end]) if params[:end]
    @routines = @routines.joins(:subject).where("subjects.id = ?", params[:subject_id]) if params[:subject_id].present?
    @routines = @routines.joins(:children).where("children.id = ?", params[:child_id]) if params[:child_id].present?
    @routines = @routines.for_parent(current_user) if current_user.has_role? :parent and params[:child_id].blank?
    @routines = @routines.published? if current_user.has_role? :parent
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @routines }
      format.json { render :json => RoutinesDatatable.new(view_context) }
      format.js  { render :json => @routines }
    end
  end
  
  def show
    @routine = Routine.scoped
    if current_user.has_role? :parent
      @routine = @routine.for_parent(current_user)
      @routine = @routine.published?
    end
    @routine = @routine.find(params[:id])
    
    if current_user.has_role? :parent
      RoutineReading.batch_increment_routines(current_user, [@routine])
    else
      @readings = RoutineReading.where(:routine_id => @routine.id)
      @total_count = @readings.inject(0){|sum, e1| sum + e1.count}
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @routine }
      format.js { render :json => @routine.to_json }
    end
  end
  
  def new
    @routine = current_user.routines.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @routine }
    end
  end
  
  def create
    @routine = current_user.routines.new(params[:routine])
    
    respond_to do |format|
      if @routine.save
        format.html { redirect_to(@routine, :notice => 'Routine was successfully created.') }
        format.xml  { render :xml => @routine, :status => :created, :location => @routine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @routine.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @routine = Routine.find(params[:id])
  end
  
  def update
    @routine = Routine.find(params[:id])
    
    respond_to do |format|
      if @routine.update_attributes(params[:routine])
        format.html { redirect_to(@routine, :notice => 'Routine was successfully updated.') }
        format.xml  { head :ok }
        format.js { head :ok}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @routine.errors, :status => :unprocessable_entity }
        format.js  { render :js => @routine.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if current_user.has_role? :admin
      @routine = Routine.find(params[:id])
    else
      @routine = current_user.routines.find(params[:id])
    end
    
    respond_to do |format|
      if @routine.destroy
        format.html { redirect_to(:back, :notice => "Routine was succesfully deleted.") }
        format.xml  { head :ok }
      end
    end    
  end
  
end

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
