RSpec.describe ParkingPlace, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number).scoped_to(:parking_id) }
  it { is_expected.to validate_presence_of(:parking_id) }
  it { is_expected.to belong_to(:parking).dependent(:destroy) }
  it { is_expected.to belong_to(:profile) }
  it { is_expected.to validate_uniqueness_of(:profile_id) }

  describe 'scopes' do
    describe 'with_owner' do
      subject { described_class.with_owner }
      context 'no places' do
        it { is_expected.to be_empty }
      end

      context 'with places' do
        let(:parking) { create :parking }
        let!(:place1) { create :parking_place, parking_id: parking.id, profile_id: profile_id }
        let!(:place2) { create :parking_place, parking_id: parking.id, number: 11, profile_id: profile2_id }

        context 'no places assigned' do
          let(:profile_id) { nil }
          let(:profile2_id) { nil }
          it { is_expected.to be_empty }
        end

        context 'with profiles' do
          let(:user) { create :user }
          let(:profile) {create :profile, user: user}
          let(:admin) { create :admin }
          let(:profile2) { create :profile, user: admin, phone_number: '1321' }
          let!(:profile_id) { profile.id }

          context 'some places assigned' do
            let!(:profile2_id) { nil }

            it { is_expected.to eq [place1] }
          end

          context 'all places assigned' do
            let!(:profile2_id) { profile2.id }

            it { is_expected.to eq [place1, place2] }
          end
        end
      end
    end
  end
end
