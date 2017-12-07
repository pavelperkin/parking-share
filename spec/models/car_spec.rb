RSpec.describe Car, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:make) }
  it { is_expected.to validate_presence_of(:model) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number) }
  it { is_expected.to validate_presence_of(:profile_id) }
  it { is_expected.to belong_to(:profile).dependent(:destroy) }
end
