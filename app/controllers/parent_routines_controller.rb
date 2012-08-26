class ParentRoutinesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :parent_only
  
  def calendar    
    @child_ids = current_user.child_ids
    @child_names = current_user.children.collect { |child| child.first_name }
    
    # from colorbrewer2.org, Set3
    @backgroundColors = ['#8DD3C7', '#FFFFB3', '#BEBADA', '#FB8072', '#80B1D3', 
                         '#FDB462', '#B3DE69', '#FCCDE5', '#D9D9D9', '#BC80BD', 
                         '#CCEBC5', '#FFED6F']
    @textColors = ['white', 'grey', 'white', 'white', 'white', 'white', 'white', 
                   'grey', 'black', 'white', 'black', 'grey']
  end
  
  def index
    @requested_day = Time.parse(params[:date]) if params[:date]
    
    children = current_user.children
    
    @routines_by_child = children.collect do |child|
      routines = child.routines.scoped
      routines = routines.range_for_day(@requested_day) if params[:date]
      routines = routines.order('starts_at DESC')
      routines = routines.published?
      RoutineReading.batch_increment_routines(current_user, routines)
      [child.name, routines]
    end
    @routines_by_child = Hash[ *@routines_by_child.flatten(1) ]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routines_by_child }
      format.js  { render :json => @routines_by_child }
    end
    
  end
  
end
