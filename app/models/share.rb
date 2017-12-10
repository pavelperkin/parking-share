class Share < ApplicationRecord
  has_one :rent
  belongs_to :profile

  validates :from_date, presence: true, allow_nil: false
  validates :to_date, presence: true, allow_nil: false
  validates :profile_id, presence: true, allow_nil: false
  validate :valid_time_interval

  def valid_time_interval
    if from_date && to_date
      errors.add(:from_date, "Should starts today or later") unless from_date >= Date.current
      errors.add(:to_date, "End date should be after from date") unless from_date <= to_date
    end
  end

  def is_active?
    self.is_active && self.to_date >= Date.current
  end
end
