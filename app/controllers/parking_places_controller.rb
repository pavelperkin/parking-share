class ParkingPlacesController < ApplicationController
  def create
    @parking_place = ParkingPlace.new(parking_place_params)
    authorize! :create, @parking_place
    if @parking_place.save
      redirect_to @parking_place.parking, notice: 'Parking place was successfully created.'
    else
      redirect_back fallback_location: root_path, alert: @parking_place.errors.full_messages.join(', ')
    end
  end

  def update
    #TODO
    @parking_place = ParkingPlace.find(params[:id])
    authorize! :update, @parking_place
    if @parking_place.update(parking_place_params)
      redirect_to @parking_place.parking, notice: 'Parking place was successfully created.'
    else
      redirect_to @parking_place.parking, alert: 'Errors!!!'
    end
  end

  def destroy
    @parking_place = ParkingPlace.find(params[:id])
    authorize! :destroy, @parking_place
    @parking_place.destroy
    redirect_to parking_path(@parking_place.parking), notice: 'Parking place was successfully destroyed.'
  end

  private

    def parking_place_params
      params.require(:parking_place).permit(:number, :parking_id, :profile_id)
    end
end
