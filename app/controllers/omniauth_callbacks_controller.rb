class OmniauthCallbacksController < ApplicationController
  def all_debug
    raise request.env["omniauth.auth"].to_yaml
  end
  
  def all
    oauth = request.env["omniauth.auth"]
    user = User.from_omniauth_find_or_create(oauth)
    if user.nil?
      flash.notice = "ERROR: Couldn't sign in via #{oauth.provider}. Please sign in normally and ensure that your first name, last name, and/or email in 'Edit Account' match with the information in #{oauth.provider}."
      redirect_to login_path
    elsif user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      flash.notice = "UNKNOWN ERROR: Contact administrator."
      redirect_to root_path
    end
  end
  
  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
