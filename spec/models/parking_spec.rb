RSpec.describe Parking, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:rank) }
  it { is_expected.to validate_numericality_of(:rank).only_integer }
  it { is_expected.to validate_presence_of(:order) }
  it { is_expected.not_to allow_value('equal').for(:order) }
  it { is_expected.not_to allow_value(nil).for(:order) }
  it { is_expected.to allow_value('asc').for(:order) }
  it { is_expected.to allow_value('desc').for(:order) }

end

