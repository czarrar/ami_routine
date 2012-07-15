class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  
  def index
    @users = User.where("id <> ?", current_user.id)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully Created User." 
      redirect_to users_path
    else
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end
    if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
      params[:user].delete(:password_confirmation)
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully Updated User."
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully Deleted User."
      redirect_to users_path
    end
  end

end
