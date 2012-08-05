class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only, :except => [:edit, :update]
  before_filter :allow_current_user, :only => [:edit, :update]
  
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
      if current_user.has_role? :admin
        redirect_to users_path
      else
        redirect_to root_path
      end
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
  
  def allow_current_user
    if current_user.id != params[:id].to_i and !current_user.has_role? :admin
      msg = "Access restricted. Contact the administrator if you think there is an error"
      redirect_to :back, :alert => msg
    end
  end
end
