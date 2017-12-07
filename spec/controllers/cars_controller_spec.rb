RSpec.describe CarsController, type: :controller do
  context 'not logged in' do
    describe 'GET #new' do
      it "redirects to sign_in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it "redirects to sign_in page" do
        post :create, params: { car: attributes_for(:car) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      it "redirects to sign_in page" do
        car = create :car
        delete :destroy, params: { id: car.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'logged in' do
    let(:user) { create :user }
    context 'not admin' do
      before :each do
        allow(controller).to receive(:authenticate_user!) { true }
        allow(controller).to receive(:current_user) { user }
        create :profile, user: user
      end

      describe 'GET #new' do
        it 'response with success' do
          get :new
          expect(response).to have_http_status(:success)
        end

        it 'render #new template' do
          get :new
          expect(response).to render_template(:new)
        end

        it 'assigns @car to new Car' do
          get :new
          expect(assigns(:car)).to be_a_new(Car)
        end

        it 'assigned @car belongs to current_profile' do
          get :new
          car = assigns(:car)
          expect(car.profile_id).to eq(user.profile.id)
        end
      end

      describe 'POST #create' do
        context 'for self profile' do
          context 'with valid params' do
            subject { post :create, params: { car: attributes_for(:car, profile_id: user.profile.id ) } }

            it 'creates new Car' do
              expect { subject }.to change { Car.count }.by(1)
            end

            it 'creates new Car for current_profile' do
              expect { subject }.to change { user.profile.cars.count }.by(1)
            end

            it 'redirects to profile_url' do
              subject
              expect(response).to redirect_to(profile_url)
            end
          end

          context 'with invalid params' do
            subject { post :create, params: { car: attributes_for(:car, make: nil, profile_id: user.profile.id) } }

            it 'not creates new Car' do
              expect { subject }.not_to change { Car.count }
            end

            it 'not creates new Car for current_profile' do
              expect { subject }.not_to change { user.profile.cars.count }
            end

            it 'notredirects to profile_url' do
              subject
              expect(response).to render_template(:new)
            end

            it 'response with success' do
              subject
              expect(response).to have_http_status(:success)
            end
          end
        end

        context 'for another profile' do
          let(:another_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com" }
          let!(:another_profile) { create :profile, user: another_user, phone_number: Faker::PhoneNumber.cell_phone}
          context 'with valid params' do
            subject { post :create, params: { car: attributes_for(:car, profile_id: another_profile.id) } }

            it 'not creates new Car' do
              expect { subject }.not_to change { Car.count }
            end

            it 'not creates new Car for current_profile' do
              expect { subject }.not_to change { another_profile.cars.count }
            end

            it 'redirects to root_url' do
              subject
              expect(response).to redirect_to(root_url)
            end
          end

          context 'with invalid params' do
            subject { post :create, params: { car: attributes_for(:car, make: nil, profile_id: another_profile.id) } }

            it 'not creates new Car' do
              expect { subject }.not_to change { Car.count }
            end

            it 'not creates new Car for current_profile' do
              expect { subject }.not_to change { another_profile.cars.count }
            end

            it 'redirects to root_url' do
              subject
              expect(response).to redirect_to(root_url)
            end
          end
        end
      end

      describe 'DELETE #destroy' do
        context 'from self profile' do
          let!(:car) { create :car, profile_id: user.profile.id }
          subject { delete :destroy, params: { id: car.id }}

          it 'deletes car' do
            expect { subject }.to change { Car.count }.by(-1)
          end

          it 'deletes car from profile' do
            expect { subject }.to change { user.profile.cars.count }.by(-1)
          end

          it 'redirects to profile_url' do
            subject
            expect(response).to redirect_to(profile_url)
          end
        end

        context 'from another profile' do
          let(:another_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com" }
          let!(:another_profile) { create :profile, user: another_user, phone_number: Faker::PhoneNumber.cell_phone}
          let!(:car) { create :car, profile_id: another_profile.id }

          subject { delete :destroy, params: { id: car.id }}

          it 'not deletes car' do
            expect { subject }.not_to change { Car.count }
          end

          it 'not deletes car from profile' do
            expect { subject }.not_to change { user.profile.cars.count }
          end

          it 'redirects to root_url' do
            subject
            expect(response).to redirect_to(root_url)
          end
        end
      end
    end

    context 'admin' do
      let(:admin) { create :admin }

      before :each do
        allow(controller).to receive(:authenticate_user!) { true }
        allow(controller).to receive(:current_user) { admin }
        create :profile, user: admin
      end

      describe 'GET #new' do
        it 'response with success' do
          get :new
          expect(response).to have_http_status(:success)
        end

        it 'render #new template' do
          get :new
          expect(response).to render_template(:new)
        end

        it 'assigns @car to new Car' do
          get :new
          expect(assigns(:car)).to be_a_new(Car)
        end

        it 'assigned @car belongs to current_profile' do
          get :new
          car = assigns(:car)
          expect(car.profile_id).to eq(admin.profile.id)
        end
      end

      describe 'POST #create' do
        context 'for self profile' do
          context 'with valid params' do
            subject { post :create, params: { car: attributes_for(:car, profile_id: admin.profile.id ) } }

            it 'creates new Car' do
              expect { subject }.to change { Car.count }.by(1)
            end

            it 'creates new Car for current_profile' do
              expect { subject }.to change { admin.profile.cars.count }.by(1)
            end

            it 'redirects to profile_url' do
              subject
              expect(response).to redirect_to(profile_url)
            end
          end

          context 'with invalid params' do
            subject { post :create, params: { car: attributes_for(:car, make: nil, profile_id: admin.profile.id) } }

            it 'not creates new Car' do
              expect { subject }.not_to change { Car.count }
            end

            it 'not creates new Car for current_profile' do
              expect { subject }.not_to change { admin.profile.cars.count }
            end

            it 'notredirects to profile_url' do
              subject
              expect(response).to render_template(:new)
            end

            it 'response with success' do
              subject
              expect(response).to have_http_status(:success)
            end
          end
        end

        context 'for another profile' do
          let(:another_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com" }
          let!(:another_profile) { create :profile, user: another_user, phone_number: Faker::PhoneNumber.cell_phone}

          context 'with valid params' do
            subject { post :create, params: { car: attributes_for(:car, profile_id: another_user.profile.id ) } }

            it 'creates new Car' do
              expect { subject }.to change { Car.count }.by(1)
            end

            it 'creates new Car for current_profile' do
              expect { subject }.to change { another_profile.cars.count }.by(1)
            end

            it 'redirects to profile_url' do
              subject
              expect(response).to redirect_to(profile_url)
            end
          end

          context 'with invalid params' do
            subject { post :create, params: { car: attributes_for(:car, make: nil, profile_id: another_user.profile.id) } }

            it 'not creates new Car' do
              expect { subject }.not_to change { Car.count }
            end

            it 'not creates new Car for current_profile' do
              expect { subject }.not_to change { another_profile.cars.count }
            end

            it 'notredirects to profile_url' do
              subject
              expect(response).to render_template(:new)
            end

            it 'response with success' do
              subject
              expect(response).to have_http_status(:success)
            end
          end
        end
      end

      describe 'DELETE #destroy' do
        subject { delete :destroy, params: { id: car.id }}

        context 'from self profile' do
          let!(:car) { create :car, profile_id: admin.profile.id }

          it 'deletes car' do
            expect { subject }.to change { Car.count }.by(-1)
          end

          it 'deletes car from profile' do
            expect { subject }.to change { admin.profile.cars.count }.by(-1)
          end

          it 'redirects to profile_url' do
            subject
            expect(response).to redirect_to(profile_url)
          end
        end

        context 'from another profile' do
          let(:another_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com" }
          let!(:another_profile) { create :profile, user: another_user, phone_number: Faker::PhoneNumber.cell_phone}
          let!(:car) { create :car, profile_id: another_profile.id }

          it 'deletes car' do
            expect { subject }.to change { Car.count }.by(-1)
          end

          it 'deletes car from profile' do
            expect { subject }.to change { another_profile.cars.count }.by(-1)
          end

          it 'redirects to profile_url' do
            subject
            expect(response).to redirect_to(profile_url)
          end
        end
      end
    end
  end
end
