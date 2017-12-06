RSpec.describe Profile, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_uniqueness_of(:phone_number) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_uniqueness_of(:user_id) }
  it { is_expected.to belong_to(:user).dependent(:destroy).inverse_of(:profile) }
  it { is_expected.to delegate_method(:email).to(:user) }
end
