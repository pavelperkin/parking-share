class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to main_app.root_url, notice: 'Not enough permissions. Please contact admins'
  end
end
