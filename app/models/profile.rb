class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile, dependent: :destroy
  has_many :cars
  has_one :parking_place

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates :user_id, presence: true, uniqueness: true

  delegate :email, to: :user

  scope :without_place, -> { where.not(id: ParkingPlace.with_owner.pluck(:profile_id)).includes(:user) }
end
