class MediaController < ApplicationController
  before_filter :authenticate_user!
  before_filter :parent_only
  
  def index
    @children = Hash[*current_user.children.collect { |child| [child.id, child.name] }.flatten]
  end
  
  def gallery
    child = current_user.children.find(params[:id])
    @has_album = child.album_id.nil? ? false : true
    if @has_album
      album = flickr.photosets.getPhotos( photoset_id: child.album_id )
      @media = album.photo      
      @media.collect! do |photo|
        flickr.photos.getInfo( photo_id: photo.id )
      end
    end
    
  end
  
end
