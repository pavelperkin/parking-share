class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :make
      t.string :model
      t.string :number
      t.integer :profile_id

      t.timestamps
    end
  end
end
