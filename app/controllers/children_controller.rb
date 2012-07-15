class ChildrenController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  
  def index
    @children = Child.all
  end
  
  def new
    @child = Child.new
  end
  
  def create
    @child = Child.new(params[:child])
    if @child.save
      flash[:notice] = "Successfully added child." 
      redirect_to children_path
    else
      render :action => 'new'
    end
  end
  
  def show
    @child = Child.find(params[:id])
  end
  
  def edit
    @child = Child.find(params[:id])
  end
  
  def update
    @child = Child.find(params[:id])
    if @child.update_attributes(params[:child])
      flash[:notice] = "Successfully updated child."
      redirect_to children_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @child = Child.find(params[:id])
    if @child.destroy
      flash[:notice] = "Successfully deleted child."
      redirect_to children_path
    end
  end
end
