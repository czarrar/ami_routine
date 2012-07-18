class SubjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  
  def index
    @subjects = Subject.all
  end
  
  def new
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(params[:subject])
    if @subject.save
      flash[:notice] = "Successfully added subject." 
      redirect_to subjects_path
    else
      render :action => 'new'
    end
  end
  
  def show
    @subject = Subject.find(params[:id])
  end
  
  def edit
    @subject = Subject.find(params[:id])
  end
  
  def update
    @subject = Subject.find(params[:id])
    if @subject.update_attributes(params[:subject])
      flash[:notice] = "Successfully updated subject."
      redirect_to subjects_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @subject = Subject.find(params[:id])
    if @subject.destroy
      flash[:notice] = "Successfully deleted subject."
      redirect_to subjects_path
    end
  end
end
