class Car < ApplicationRecord
  belongs_to :profile, dependent: :destroy

  validates :make, presence: true
  validates :model, presence: true
  validates :number, presence: true, uniqueness: true
  validates :profile_id, presence: true
end
