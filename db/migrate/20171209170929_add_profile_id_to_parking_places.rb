class AddProfileIdToParkingPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :parking_places, :profile_id, :integer
  end
end
