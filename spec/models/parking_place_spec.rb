RSpec.describe ParkingPlace, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:parking_id) }
  it { is_expected.to validate_presence_of(:parking_id) }
  it { is_expected.to belong_to(:parking).dependent(:destroy) }
end
