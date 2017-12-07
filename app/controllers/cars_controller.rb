class CarsController < ApplicationController
  def new
    @car = current_profile.cars.new
    authorize! :create, @car
  end

  def create
    @car = Car.new(car_params)
    authorize! :create, @car
    if @car.save
      redirect_to profile_url, notice: 'Car was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @car = Car.find(params[:id])
    authorize! :destroy, @car
    @car.destroy
    redirect_to profile_url, notice: 'Car was successfully destroyed.'
  end

  private
    def car_params
      params.require(:car).permit(:make, :model, :number, :profile_id)
    end
end
