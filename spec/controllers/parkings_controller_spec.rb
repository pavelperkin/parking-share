RSpec.describe ParkingsController, type: :controller do
  let(:parking) { create :parking }

  context 'not logged' do
    describe 'GET #new' do
      it "redirects to sign_in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #edit' do
      it "redirects to sign_in page" do
        get :edit, params: { id: parking.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #index' do
      it "redirects to sign_in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #show' do
      it "redirects to sign_in page" do
        get :show, params: { id: parking.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it "redirects to sign_in page" do
        post :create, params: { parking: attributes_for(:parking) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH #update' do
      it "redirects to sign_in page" do
        patch :update, params: { id: parking.id, parking: attributes_for(:parking) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      it "redirects to sign_in page" do
        delete :destroy, params: { id: parking.id }
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

      describe 'GET #new' do
        it 'redirects to root_url' do
          get :new
          expect(response).to redirect_to(root_url)
        end
      end

      describe 'GET #edit' do

        it 'redirects to root_url' do
          get :edit, params: { id: parking.id }
          expect(response).to redirect_to(root_url)
        end
      end

      describe 'GET #index' do
        subject { get :index }

        it 'response with success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'render #index template' do
          subject
          expect(response).to render_template(:index)
        end

        context 'result' do
          let!(:parking1) { create :parking }
          let!(:parking2) { create :parking, name: Faker::LordOfTheRings.location }

          it 'assigns @parking to Parking' do
            subject
            expect(assigns(:parkings)).to eq ([parking1, parking2])
          end
        end
      end

      describe 'GET #show' do
        subject { get :show, params: { id: parking.id } }

        it 'response with success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'render #show template' do
          subject
          expect(response).to render_template(:show)
        end

        it 'assigns @parking to Parking' do
          subject
          expect(assigns(:parking)).to eq (parking)
        end
      end

      describe 'POST #create' do
        subject { post :create, params: { parking: attributes_for(:parking) } }

        it 'does not create a parking' do
          expect { subject }.not_to change { Parking.count }
        end

        it "redirects to root_url" do
          subject
          expect(response).to redirect_to(root_url)
        end
      end

      describe 'PATCH #update' do
        subject { patch :update, params: { id: parking.id, parking: attributes_for(:parking, name: 'test name') } }

        it 'does not update a parking' do
          parking
          expect { subject }.not_to change { parking.reload.name }
        end

        it "redirects to root_url" do
          subject
          expect(response).to redirect_to(root_url)
        end
      end

      describe 'DELETE #destroy' do
        subject { delete :destroy, params: { id: parking.id } }

        it "redirects to sign_in page" do
          subject
          expect(response).to redirect_to(root_url)
        end

        it 'does not delete a parking' do
          parking
          expect { subject }.not_to change { Parking.count }
        end
      end
    end

    context 'admin' do
      let(:user) { create :admin }

      describe 'GET #new' do
        subject { get :new }

        it 'response with success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'render #new template' do
          subject
          expect(response).to render_template(:new)
        end

        it 'assigns @parking to Parking' do
          subject
          expect(assigns(:parking)).to be_a_new(Parking)
        end
      end

      describe 'GET #edit' do
        subject { get :edit, params: { id: parking.id } }

        it 'response with success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'render #edit template' do
          subject
          expect(response).to render_template(:edit)
        end

        it 'assigns @parking to Parking' do
          subject
          expect(assigns(:parking)).to eq (parking)
        end
      end

      describe 'GET #index' do
        subject { get :index }

        it 'response with success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'render #index template' do
          subject
          expect(response).to render_template(:index)
        end

        context 'result' do
          let!(:parking1) { create :parking }
          let!(:parking2) { create :parking, name: Faker::LordOfTheRings.location }

          it 'assigns @parking to Parking' do
            subject
            expect(assigns(:parkings)).to eq ([parking1, parking2])
          end
        end
      end

      describe 'GET #show' do
        subject { get :show, params: { id: parking.id } }

        it 'response with success' do
          subject
          expect(response).to have_http_status(:success)
        end

        it 'render #show template' do
          subject
          expect(response).to render_template(:show)
        end

        it 'assigns @parking to Parking' do
          subject
          expect(assigns(:parking)).to eq (parking)
        end
      end

      describe 'POST #create' do
        context 'valid params' do
          subject { post :create, params: { parking: attributes_for(:parking) } }

          it 'creates a parking' do
            expect { subject }.to change { Parking.count }.by(1)
          end

          it "redirects to parkings_url" do
            subject
            expect(response).to redirect_to(parkings_url)
          end
        end

        context 'invalid params' do
          subject { post :create, params: { parking: attributes_for(:parking, name: nil) } }

          it 'does not create a parking' do
            expect { subject }.not_to change { Parking.count }
          end

          it "render new template" do
            subject
            expect(response).to render_template(:new)
          end
        end
      end

      describe 'PATCH #update' do
        context 'valid params' do
          subject { patch :update, params: { id: parking.id, parking: attributes_for(:parking, name: 'test name') } }

          it 'updates a parking' do
            parking
            expect { subject }.to change { parking.reload.name }.to('test name')
          end

          it "redirects to parkings_url" do
            subject
            expect(response).to redirect_to(parkings_url)
          end
        end

        context 'invalid params' do
          subject { patch :update, params: { id: parking.id, parking: attributes_for(:parking, name: nil) } }

          it 'does not update a parking' do
            parking
            expect { subject }.not_to change { parking.reload.name }
          end

          it "renders edit template" do
            subject
            expect(response).to render_template(:edit)
          end
        end

      end

      describe 'DELETE #destroy' do
        subject { delete :destroy, params: { id: parking.id } }

        it "redirects to sign_in page" do
          subject
          expect(response).to redirect_to(parkings_url)
        end

        it 'does not delete a parking' do
          parking
          expect { subject }.to change { Parking.count }.by(-1)
        end
      end
    end
  end
end
