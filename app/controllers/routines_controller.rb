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
      format.html # index.html.erb
      format.xml  { render :xml => @routines }
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
