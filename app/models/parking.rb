class Parking < ApplicationRecord
  has_many :parking_places

  validates :name, presence: true, uniqueness: true
  validates :rank, presence: true, numericality: { only_integer: true }
  validates :order, presence: true, inclusion: { in: %w(asc desc) }, allow_nil: false
end
