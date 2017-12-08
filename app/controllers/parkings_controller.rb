class ParkingsController < ApplicationController
  before_action :set_parking, only: [:show, :edit, :update, :destroy]

  def index
    @parkings = Parking.all
    authorize! :read, @parkings
  end

  def show
    authorize! :read, @parking
  end

  def new
    @parking = Parking.new
    authorize! :create, @parking
  end

  def edit
    authorize! :edit, @parking
  end

  def create
    @parking = Parking.new(parking_params)
    authorize! :create, @parking
    if @parking.save
      redirect_to parkings_url, notice: 'Parking was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, @parking
    if @parking.update(parking_params)
      redirect_to parkings_url, notice: 'Parking was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @parking
    @parking.destroy
    redirect_to parkings_url, notice: 'Parking was successfully destroyed.'
  end

  private
    def set_parking
      @parking = Parking.find(params[:id])
    end

    def parking_params
      params.require(:parking).permit(:name, :rank, :order)
    end
end
