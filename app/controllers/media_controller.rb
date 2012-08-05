class MediaController < ApplicationController
  before_filter :authenticate_user!
  before_filter :parent_only
  
  def index
    @children = Hash[*current_user.children.collect { |child| [child.id, child.name] }.flatten]
  end
  
  def gallery
    child = current_user.children.find(params[:id])
    @has_album = child.album_id.nil? || child.album_key.nil? ? false : true
    if @has_album
      smug = get_smugmug
      album = Smile::Album.find(:album_id => child.album_id, :album_key => child.album_key)
      @media = album.photos
#      binding.pry
    end
    
  end
  
end
