RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('admin@lohika.com').for(:email) }
  it { is_expected.not_to allow_value('admin@example.com').for(:email) }
  it { is_expected.not_to allow_value('admin-example.com').for(:email) }
end
