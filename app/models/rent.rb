class Rent < ApplicationRecord
  belongs_to :share
  belongs_to :profile

  validates :from_date, presence: true, allow_nil: false
  validates :to_date, presence: true, allow_nil: false
  validates :profile_id, presence: true, allow_nil: false
  validates :share_id, presence: true, allow_nil: false
  validate :valid_time_interval
  validate :different_profile_with_share

  after_commit :create_a_share

  def valid_time_interval
    if from_date && to_date && share
      errors.add(:from_date, "Should not start before share starts") unless from_date >= share.from_date
      errors.add(:from_date, "Should not start when share ends") unless from_date <= share.to_date
      errors.add(:to_date, "End date should be after from date") unless from_date <= to_date
      errors.add(:to_date, "Should not ends after share ends") unless to_date <= share.to_date
    end
  end

  def different_profile_with_share
    if share
      errors.add(:profile_id, "You can't rent the place you shared") if profile_id == share.profile_id
    end
  end

  def create_a_share
    factory.share_origin_place
    factory.deactivate_rented_share
    factory.create_additional_shares
  end

  def is_active?
    self.to_date >= Date.current
  end

  private

  def factory
    @factory ||= SharesAbstractFactory.new(self)
  end
end
