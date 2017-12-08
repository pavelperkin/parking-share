RSpec.describe ParkingPlacesController, type: :controller do
  let(:parking) { create :parking }
  let(:place) { create :parking_place, parking: parking }

  context 'not logged in' do
    describe 'POST #create' do
      subject { post :create, params: { parking_place: attributes_for(:parking_place, parking: parking )}}

      it 'redirects to login page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      subject { delete :destroy, params: { id: parking.id } }

      it 'redirects to login page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'logged in' do
    before :each do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
      create :profile, user: user
    end

    context 'not admin' do
      let(:user) { create :user }

      describe 'POST #create' do
        subject { post :create, params: { parking_place: attributes_for(:parking_place, parking_id: parking.id )}}

        it 'redirects to root_url' do
          subject
          expect(response).to redirect_to(root_url)
        end

        it 'does not create a parking place' do
          expect { subject }.not_to change { ParkingPlace.count }
        end

        it 'does not create a parking place for parking' do
          expect { subject }.not_to change { parking.parking_places.count }
        end
      end

      describe 'DELETE #destroy' do
        before do
          place
        end

        subject { delete :destroy, params: { id: place.id } }

        it 'redirects to root_url' do
          subject
          expect(response).to redirect_to(root_url)
        end

        it 'does not destroy a parking place' do
          expect { subject }.not_to change { ParkingPlace.count }
        end

        it 'does not destroy a parking place for parking' do
          expect { subject }.not_to change { parking.parking_places.count }
        end
      end
    end

    context 'admin' do
      let(:user) { create :admin }

      describe 'POST #create' do
        context 'with valid params' do
          subject { post :create, params: { parking_place: attributes_for(:parking_place, parking_id: parking.id )}}

          it 'redirects to parking' do
            subject
            expect(response).to redirect_to(parking)
          end

          it 'does create a parking place' do
            expect { subject }.to change { ParkingPlace.count }.by(1)
          end

          it 'does create a parking place for parking' do
            expect { subject }.to change { parking.parking_places.count }.by(1)
          end
        end

        context 'with invalid params' do
          subject { post :create, params: { parking_place: attributes_for(:parking_place, parking_id: nil )}}

          it 'redirects to root_url' do
            subject
            expect(response).to redirect_to(root_url) #fallback url
          end

          it 'does create a parking place' do
            expect { subject }.not_to change { ParkingPlace.count }
          end

          it 'does create a parking place for parking' do
            expect { subject }.not_to change { parking.parking_places.count }
          end
        end
      end

      describe 'DELETE #destroy' do
        before do
          place
        end

        subject { delete :destroy, params: { id: place.id } }

        it 'redirects to parking path' do
          subject
          expect(response).to redirect_to(parking_path(parking))
        end

        it 'does destroy a parking place' do
          expect { subject }.to change { ParkingPlace.count }.by(-1)
        end

        it 'does destroy a parking place for parking' do
          expect { subject }.to change { parking.parking_places.count }.by(-1)
        end
      end
    end
  end
end
