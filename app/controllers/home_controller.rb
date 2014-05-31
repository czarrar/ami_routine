class HomeController < ApplicationController
  def index    
    if user_signed_in? and current_user.has_role? :parent
      # Get routines completed on the most recent day
      child_names = current_user.children
      @children = child_names.collect do |child|
        routines = child.routines.published?
        routines = routines.order('starts_at DESC')
        # keep all routines from the latest day
        latest_routine = routines.limit(1).first
        if latest_routine
          requested_day = latest_routine.ends_at.midnight
          routines = routines.range_for_day(requested_day)
          RoutineReading.batch_increment_routines(current_user, routines)
        else
          requested_day = Time.now.midnight
          routines = []
        end
        
        has_album = child.album_id.nil? ? false : true
        if has_album
          album = flickr.photosets.getPhotos( photoset_id: child.album_id )
          photos = album.photo
          # keep the 5 most recent photos
          i = photos.length > 4 ? photos.length - 5 : 0
          photos = photos[i..-1]
        else
          photos = []
        end
        
        {name: child.name, date: requested_day, routines: routines, photos: photos}
      end
    end
  end

  def contact
  end
end
