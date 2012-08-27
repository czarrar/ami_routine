class ChildrenController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  
  def index
    @children = Child.all
  end
  
  def new
    @child = Child.new
    
    set_vars_for_child_user
    
    smug = get_smugmug
    @albums = smug.albums.collect {|album| [album.title, "#{album.id} #{album.key}"] }
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
    @child.album = "#{@child.album_id} #{@child.album_key}" if @child.album_id and @child.album_key
    
    set_vars_for_child_user
    
    smug = get_smugmug
    @albums = smug.albums.collect {|album| [album.title, "#{album.id} #{album.key}"] }
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
  
  def set_vars_for_child_user
    @parents = User.joins(:roles).where("roles.name = 'parent'")
    @child_users = @child.child_users
    @child_users = @child.child_users.new if @child_users.empty?
    @relationships = ["Father", "Mother", "Uncle", "Aunt", "Grandfather", 
                      "Grandmother", "Other"]
  end
end
