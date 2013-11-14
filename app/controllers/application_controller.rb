class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :curr_user

  def curr_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
