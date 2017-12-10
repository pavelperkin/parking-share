RSpec.describe Share, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:from_date) }
  it { is_expected.to validate_presence_of(:to_date) }
  it { is_expected.to validate_presence_of(:profile_id) }
  it { is_expected.to belong_to(:profile) }
  it { is_expected.to have_one(:rent) }

  describe 'custom validations' do
    describe 'valid_time_interval' do
      subject { share.valid? }

      context 'from date before today' do
        let(:share) { build :share, from_date: 5.days.ago }
        it { is_expected.to be_falsy}
      end

      context 'from date today' do
        let(:share) { build :share }
        it { is_expected.to be_truthy }
      end

      context 'from date after today' do
        let(:share) { build :share, from_date: 5.days.since }
        it { is_expected.to be_truthy}
      end

      context 'to date before from date' do
        let(:share) { build :share, to_date: 5.days.ago }
        it { is_expected.to be_falsy }
      end

      context 'to date equals from date' do
        let(:share) { build :share, to_date: Date.current }
        it { is_expected.to be_truthy }
      end

      context 'to date after from date' do
        let(:share) { build :share }
        it { is_expected.to be_truthy }
      end
    end
  end
end
