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
  it { is_expected.to have_many(:cars) }
  it { is_expected.to have_one(:parking_place) }

  describe 'scopes' do
    describe 'without_place' do
      subject { described_class.without_place }

      context 'no profiles' do
        it { is_expected.to be_empty }
      end

      context 'profiles exist' do
        let(:user) { create :user }
        let!(:profile) {create :profile, user: user}
        let(:admin) { create :admin }
        let!(:profile2) { create :profile, user: admin, phone_number: '1321' }

        context 'all profiles are without places' do
          it { is_expected.to eq [profile, profile2] }
        end

        context 'with places' do
          let(:parking) { create :parking }
          let!(:place1) { create :parking_place, profile_id: profile.id, parking_id: parking.id}
          context 'all profiles have parking_place' do
            let!(:place2) { create :parking_place, profile_id: profile2.id, parking_id: parking.id, number: 11}

            it { is_expected.to be_empty }
          end

          context 'some profiles have a parking_place' do
            it { is_expected.to eq [profile2] }
          end
        end
      end
    end
  end
end
