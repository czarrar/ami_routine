class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # got these tips from
  # http://lyconic.com/blog/2010/08/03/dry-up-your-ajax-code-with-the-jquery-rest-plugin
  before_filter :correct_safari_and_ie_accept_headers
  after_filter :set_xhr_flash
  
  helper_method :day_teacher_routines_path
  
  
  ###
  # AJAX-based functions
  # used with jquery.REST
  ###
  
  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
  end
  
  ###
  # Hooks around login/logout
  # that setup smugmug api
  ###
  
  def get_smugmug
    smug = Smile::Smug.new
    smug.session.id = session[:smugmug_session]
    smug.default_params
    smug
  end
    
  def after_sign_in_path_for(resource)
    smug = Smile.auth('ismat7@gmail.com', 'hello101')
    session[:smugmug_session] = smug.session.id
    if (request.referer == login_url)
      super
    else
      request.referer || stored_location_for(resource) || root_path
    end
  end
  
  def after_sign_out_path_for(resource)
    begin
      smug = get_smugmug
      smug.logout
      session[:smugmug_session] = nil
    rescue Smile::Exception
      
    end
    root_path
  end
  
  ###
  # Helpers
  ###
  
  def day_teacher_routines_path(date)
    "/teacher_routines/day/#{date.strftime('%-d-%-m-%Y')}"
  end
  
  private
  
    def admin_only
      msg = "Access restricted. Contact the administrator if you think there is an error"
      redirect_to :back, :alert => msg if !current_user.has_role? :admin
    end
  
    def teacher_only
      msg = "Access restricted. Contact the administrator if you think there is an error"
      redirect_to :back, :alert => msg if !current_user.has_role? :teacher
    end
  
    def parent_only
      msg = "Access restricted. Contact the administrator if you think there is an error"
      redirect_to :back, :alert => msg if !current_user.has_role? :parent
    end
  
    def email_only
      msg = "Access restricted. Contact the administrator if you think there is an error"
      redirect_to :back, :alert => msg if !current_user.has_role? :email
    end
  
end
