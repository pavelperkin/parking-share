class CreateParkingPlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :parking_places do |t|
      t.integer :number
      t.integer :parking_id

      t.timestamps
    end
  end
end
