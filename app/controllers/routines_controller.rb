class RoutinesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @routines = Routine.all
  end
  
  def new
    @routine = current_user.routines.new
  end
  
  def create
    @routine = current_user.routines.new(params[:routine])
    if @routine.save
      flash[:notice] = "Successfully added routine." 
      redirect_to routines_path
    else
      render :action => 'new'
    end
  end
  
  def show
    @routine = current_user.routines.find(params[:id])
  end
  
  def edit
    @routine = current_user.routines.find(params[:id])
  end
  
  def update
    @routine = current_user.routines.find(params[:id])
    if @routine.update_attributes(params[:routine])
      flash[:notice] = "Successfully updated routine."
      redirect_to routines_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @routine = current_user.routines.find(params[:id])
    if @routine.destroy
      flash[:notice] = "Successfully deleted routine."
      redirect_to routines_path
    end
  end
end
