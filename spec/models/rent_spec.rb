RSpec.describe Rent, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:share_id) }
  it { is_expected.to validate_presence_of(:from_date) }
  it { is_expected.to validate_presence_of(:to_date) }
  it { is_expected.to validate_presence_of(:profile_id) }

  it { is_expected.to belong_to(:profile) }
  it { is_expected.to belong_to(:share) }

  describe 'custom validations' do
    let(:user) { create :user }
    let(:user_profile) { create :profile, user: user }
    let(:admin) { create :admin }
    let(:admin_profile) { create :profile, user: admin, phone_number: '1321' }
    let(:share) { create :share, from_date: Date.current, to_date: 15.days.since, profile: admin_profile }

    subject { rent.valid? }

    describe 'different_profile_with_share' do
      context 'share and rent has same profile' do
        let(:rent) { build :rent, share: share, profile: admin_profile }
        it { is_expected.to be_falsy }
      end

      context 'share and rent have different profiles' do
        let(:rent) { build :rent, share: share, profile: user_profile }
        it { is_expected.to be_truthy }
      end
    end

    describe 'valid_time_interval' do
      context 'from date before share from date' do
        let(:rent) { build :rent, share: share, from_date: share.from_date - 5.days, profile: user_profile }
        it { is_expected.to be_falsy}
      end

      context 'from date on share from date' do
        let(:rent) { build :rent, share: share, from_date: share.from_date, profile: user_profile }
        it { is_expected.to be_truthy }
      end

      context 'from date after share from date' do
        let(:rent) { build :rent, share: share, from_date: share.from_date + 2.days, profile: user_profile }
        it { is_expected.to be_truthy }
      end

      context 'from date on share to date' do
        let(:rent) { build :rent, share: share, from_date: share.to_date, to_date: share.to_date, profile: user_profile }
        it { is_expected.to be_truthy}
      end

      context 'from date after share to date' do
        let(:rent) { build :rent, share: share, from_date: share.to_date + 2.days, to_date: share.to_date, profile: user_profile }
        it { is_expected.to be_falsy}
      end


      context 'to_date before from_date' do
        let(:rent) { build :rent, share: share, to_date: 5.days.ago, profile: user_profile }
        it { is_expected.to be_falsy}
      end

      context 'to_date on from_date' do
        let(:rent) { build :rent, share: share, to_date: 5.days.since, from_date: 5.days.since, profile: user_profile }
        it { is_expected.to be_truthy}
      end

      context 'to_date after from_date' do
        let(:rent) { build :rent, share: share, to_date: 7.days.since, profile: user_profile }
        it { is_expected.to be_truthy}
      end

      context 'to_date before share.to_date' do
        let(:rent) { build :rent, share: share, to_date: share.to_date - 2.days, profile: user_profile }
        it { is_expected.to be_truthy}
      end

      context 'to_date on share.to_date' do
        let(:rent) { build :rent, share: share, to_date: share.to_date, profile: user_profile }
        it { is_expected.to be_truthy}
      end

      context 'to_date after share.to_date' do
        let(:rent) { build :rent, share: share, to_date: share.to_date + 2.days, profile: user_profile }
        it { is_expected.to be_falsy}
      end
    end
  end

  describe 'is_active?' do
    let(:user) { create :user }
    let(:user_profile) { create :profile, user: user }
    let(:admin) { create :admin }
    let(:admin_profile) { create :profile, user: admin, phone_number: '1321' }
    let(:share) { create :share, from_date: Date.current, to_date: 15.days.since, profile: admin_profile }

    subject { rent.is_active? }

    context 'to_date before today' do
      let(:rent) { build :rent, to_date: 1.day.ago, profile: user_profile, share: share }
      it { is_expected.to be_falsy }
    end

    context 'to_date is today' do
      let(:rent) { build :rent, to_date: Date.current, profile: user_profile, share: share }
      it { is_expected.to be_truthy }
    end

    context 'to_date after today' do
      let(:rent) { build :rent, profile: user_profile, share: share }
      it { is_expected.to be_truthy }
    end

  end
end

