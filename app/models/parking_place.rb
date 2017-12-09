class ParkingPlace < ApplicationRecord
  belongs_to :parking, dependent: :destroy
  belongs_to :profile, optional: true

  validates :number, presence: true, uniqueness: { scope: :parking_id }
  validates :parking_id, presence: true
  validates :profile_id, uniqueness: true, allow_nil: true

  scope :with_owner, -> { where.not(profile_id: nil) }
end
