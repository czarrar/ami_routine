class TeacherRoutinesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only
  
  def calendar
    @subject_ids = Subject.all.collect { |subject| subject.id }
    
    # from colorbrewer2.org, Set3
    @backgroundColors = ['#8DD3C7', '#FFFFB3', '#BEBADA', '#FB8072', '#80B1D3', 
                         '#FDB462', '#B3DE69', '#FCCDE5', '#D9D9D9', '#BC80BD', 
                         '#CCEBC5', '#FFED6F']
    @textColors = ['white', 'grey', 'white', 'white', 'white', 'white', 'white', 
                   'grey', 'black', 'white', 'black', 'grey']
    
    # TODO: code breaks if number of subjects >12
    
  end
  
  def new
    @requested_day = Time.parse(params[:date])  # require params[:date]
    @routines = [current_user.routines.new]
  end
  
  def create
    begin
      ActiveRecord::Base.transaction do
        @routines = params[:routine].collect do |i, routine_hash|
          routine_hash = routine_hash.merge(params[:routine_base])
          current_user.routines.new(routine_hash)
        end
        results = @routines.collect { |routine| routine.save }
        raise Exception, 'Couldn\'t save one or more records' if results.include? false
      end
    rescue Exception
      result = false
    else
      result = true
    end
    
    @requested_day = Time.parse(params[:routine_base][:starts_at]).midnight
    respond_to do |format|
      if result
        format.html { redirect_to(day_teacher_routines_path(@requested_day), :notice => 'Routines were successfully created.') }
      else
        format.html { render "new" } # :action => "new", :date => "4-7-2012" ) }
      end
    end
  end
  
  def edit
    @requested_day = Time.parse(params[:date])
    @routines = Routine.scoped
    @routines = @routines.range_for_day(@requested_day)
    @routines = @routines.joins(:subject).order("subjects.name")
  end
  
  def update
    begin
      ActiveRecord::Base.transaction do
        @routines = params[:routine].collect do |i, routine_hash|
          routine = Routine.find(routine_hash[:id])
          routine_hash.delete(:id)
          routine
        end
        results = @routines.each_with_index.collect do |routine, i|
          routine.update_attributes(params[:routine][i])
        end
        raise Exception, 'Couldn\'t update one or more records' if results.include? false
      end
    rescue Exception
      result = false
    else
      result = true
    end
    
    @requested_day = Time.parse(params[:routine]['0'][:starts_at]).midnight
    respond_to do |format|
      if result
        format.html { redirect_to(day_teacher_routines_path(@requested_day), :notice => 'Routines were successfully updated.') }
      else
        format.html { render "edit" }
      end
    end    
  end
  
  def index
    @routines = Routine.scoped
    @routines = @routines.after(params[:start]) if params[:start]
    @routines = @routines.before(params[:end]) if params[:end]
    @routines = @routines.range_for_day(Time.parse(params[:date])) if params[:date]
    @routines = @routines.joins(:subject).order("subjects.name")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routines }
      format.js  { render :json => @routines }
    end
    
  end
end
