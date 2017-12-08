class ParkingPlace < ApplicationRecord
  belongs_to :parking, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :parking_id }
  validates :parking_id, presence: true
end
