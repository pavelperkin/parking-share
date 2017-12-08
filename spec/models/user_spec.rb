RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('admin@lohika.com').for(:email) }
  it { is_expected.not_to allow_value('admin@example.com').for(:email) }
  it { is_expected.not_to allow_value('admin-example.com').for(:email) }
  it { is_expected.to have_one(:profile) }

  describe 'scopes' do
    describe 'by_roles' do
      let!(:user1) { create(:user, email: 'userfirst@lohika.com') }
      let!(:user2) { create(:user, email: 'usersecond@lohika.com') }
      let!(:admin) { create(:admin) }
      let!(:user3) { create(:user, email: 'userthird@lohika.com') }

      subject { described_class.by_roles }

      it { is_expected.to eq [admin, user1, user2, user3] }
    end
  end

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
