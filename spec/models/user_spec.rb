RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('admin@lohika.com').for(:email) }
  it { is_expected.not_to allow_value('admin@example.com').for(:email) }
  it { is_expected.not_to allow_value('admin-example.com').for(:email) }

  describe '#admin' do
    subject { user.admin? }
    context 'admin user' do
      let(:user) { build(:admin) }
      it { is_expected.to be_truthy }
    end

    context 'not admin' do
      let(:user) { build(:user) }
      it { is_expected.to be_falsey }
    end
  end
end
