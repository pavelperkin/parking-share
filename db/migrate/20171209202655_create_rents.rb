class CreateRents < ActiveRecord::Migration[5.1]
  def change
    create_table :rents do |t|
      t.date :from_date
      t.date :to_date
      t.integer :share_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
