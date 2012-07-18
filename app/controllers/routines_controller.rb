class RoutinesController < ApplicationController
  before_filter :authenticate_user!
  
  before_filter :teacher_only, :only => ["teacher", "teacher_submit", "new", 
                                         "create", "edit", "update", "destroy"]
  
  ###
  # Parent/Teacher Interface
  ###
  
  def calendar
    # can this code be made more succint?
    @role = current_user.roles.any? { |role| role.name == "teacher" } ? "teacher" : nil
    @role ||= current_user.roles.any? { |role| role.name == "parent" } ? "parent" : nil
    # raise exception if @role == nil
    
    @child_ids = current_user.child_ids
    @child_names = current_user.children.collect { |child| child.first_name }
    
    # from colorbrewer2.org, Set3
    @backgroundColors = ['#8DD3C7', '#FFFFB3', '#BEBADA', '#FB8072', '#80B1D3', 
                         '#FDB462', '#B3DE69', '#FCCDE5', '#D9D9D9', '#BC80BD', 
                         '#CCEBC5', '#FFED6F']
    @textColors = ['white', 'grey', 'white', 'white', 'white', 'white', 'white', 
                   'grey', 'black', 'white', 'black', 'grey']
  end
  
  def teacher
    @requested_day = Time.local(params['year'], params['month'], params['day'])
    @children_for_select = Child.all.collect { |child| [child.name, child.id] }
  end
  
  def teacher_submit
    errors = params[:routine].collect do |i, routine_hash|
      routine_hash = routine_hash.merge(params[:routine_base])
      
      routine = current_user.routines.new(routine_hash)
      routine.save
      
      routine.errors.messages
    end          
    
    # for now ignore error messages
  end
  
  def parent
    @requested_day = Time.local(params['year'], params['month'], params['day'])
    
    routines = Routine.scoped
    routines = routines.where("starts_at >= :start AND ends_at < :end", 
                  { :start => @requested_day, :end => @requested_day + 1.day })
    routines = routines.for_parent(current_user)
    routines = routines.order('starts_at ASC')
    
    @routines_by_child = routines.group_by { |routine| routine.child.name }
  end
  
  
  ###
  # CRUD
  ###
  
  def index
    @routines = Routine.scoped
    @routines = @routines.after(params[:start]) if params[:start]
    @routines = @routines.before(params[:end]) if params[:end]
    @routines = @routines.where("child_id = ?", params[:child_id]) if params[:child_id].present?
    @routines = @routines.for_parent(current_user) if current_user.has_role? :parent and params[:child_id].blank?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routines }
      format.js  { render :json => @routines }
    end
  end
  
  def show
    @routine = Routine.scoped
    @routine = @routine.for_parent(current_user) if current_user.has_role? :parent
    @routine = @routine.find(params[:id])
    
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
    @routine = current_user.routines.find(params[:id])
  end
  
  def update
    @routine = current_user.routines.find(params[:id])
    
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
    @routine = current_user.routines.find(params[:id])
    
    respond_to do |format|
      if @routine.destroy
        format.html { redirect_to(routines_url, :notice => "Routine was succesfully deleted.") }
        format.xml  { head :ok }
      end
    end    
  end
  
end
