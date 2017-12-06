class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates :user_id, presence: true, uniqueness: true

  delegate :email, to: :user
end
