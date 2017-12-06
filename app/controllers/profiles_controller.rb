class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: 'Profile was successfully updated.'
    else
      flash[:alert] = @profile.errors.full_messages.join('; ')
      render :edit
    end
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to profile_path, notice: 'Profile was successfully created.'
    else
      flash[:alert] = @profile.errors.full_messages.join('; ')
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile || current_user.build_profile
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone_number, :user_id)
  end
end
