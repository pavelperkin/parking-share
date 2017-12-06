RSpec.describe ProfilesController, type: :controller do
  let(:user) { create :user }
  context 'not logged in' do
    describe "GET #show" do
      it "redirects to login page" do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do
      it "redirects to login page" do
        get :edit
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH #update' do
      before :each do
        create :profile, user: user
      end

      it "redirects to login page" do
        patch :update, params: { profile: attributes_for(:profile) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'logged in' do
    before :each do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        get :edit
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST #create' do

      context 'valid params' do
        it "redirects profile path" do
          post :create, params: { profile: attributes_for(:profile) }
          expect(response).to redirect_to(profile_path)
        end
      end

      context 'invalid params' do
        it "redirects profile edit path" do
          patch :create, params: { profile: { first_name: nil } }
          expect(response).to have_http_status(:success)
          expect(controller).to set_flash[:alert]
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        create :profile, user: user
      end
      context 'valid params' do
        it "redirects profile path" do
          patch :update, params: { profile: { first_name: 'Test name' } }
          expect(response).to redirect_to(profile_path)
        end
      end

      context 'invalid params' do
        it "redirects profile edit path" do
          patch :update, params: { profile: { first_name: nil } }
          expect(response).to have_http_status(:success)
          expect(controller).to set_flash[:alert]
        end
      end
    end
  end
end
