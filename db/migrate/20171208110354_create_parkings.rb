class CreateParkings < ActiveRecord::Migration[5.1]
  def change
    create_table :parkings do |t|
      t.string :name
      t.integer :rank
      t.string :order

      t.timestamps
    end
  end
end
