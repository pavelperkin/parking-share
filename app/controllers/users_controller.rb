class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.by_roles
    authorize! :read, @users
  end

  def edit
    authorize! :manage, @user
  end

  def create
    @user = UserFactory.by_email(email: user_params[:email])
    authorize! :manage, @user
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      redirect_to users_path, alert: @user.errors.full_messages.join('; ')
    end
  end

  def update
    authorize! :manage, @user
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      flash[:alert] = @user.errors.full_messages.join('; ')
      render :edit
    end
  end

  def destroy
    authorize! :manage, @user
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :admin)
  end
end
