class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # got these tips from
  # http://lyconic.com/blog/2010/08/03/dry-up-your-ajax-code-with-the-jquery-rest-plugin
  before_filter :correct_safari_and_ie_accept_headers
  after_filter :set_xhr_flash

  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
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
  
end
