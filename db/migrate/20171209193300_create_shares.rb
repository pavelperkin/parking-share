class CreateShares < ActiveRecord::Migration[5.1]
  def change
    create_table :shares do |t|
      t.date :from_date
      t.date :to_date
      t.integer :profile_id
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
