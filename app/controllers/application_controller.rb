class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :force_to_fill_profile!

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to main_app.root_url, notice: 'Not enough permissions. Please contact admins'
  end

  def current_profile
      current_user&.profile
  end

  def force_to_fill_profile!
    if user_signed_in?
      redirect_to edit_profile_path unless current_profile
    end
  end
end
