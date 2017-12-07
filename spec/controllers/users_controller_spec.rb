RSpec.describe UsersController, type: :controller do
  context 'not logged in' do
    describe "GET #index" do
      it "redirects to sign_in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do
      it "redirects to sign_in page" do
        post :create, params: { user: { email: 'user@lohika.com', admin: false } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }
      it "redirects to sign_in page" do
        get :edit, params: { id: new_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #update" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }
      it "redirects to sign_in page" do
        patch :update, params: { id: new_user.id, user: { admin: true } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #destroy" do
      it "redirects to sign_in page" do
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'not admin' do
    before :each do
      user = create :user
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
      create :profile, user: user
    end

    describe "GET #index" do
      it "shows users list" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      it "redirects to root page" do
        post :create, params: { user: { email: "#{Faker::Internet.user_name}@lohika.com", admin: false } }
        expect(response).to redirect_to(root_url)
      end
    end

    describe "GET #edit" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }
      it "redirects to root page" do
        get :edit, params: { id: new_user.id }
        expect(response).to redirect_to(root_url)
      end
    end

    describe "PATCH #update" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }
      it "redirects to root page" do
        patch :update, params: { id: new_user.id, user: { admin: true } }
        expect(response).to redirect_to(root_url)
      end
    end

    describe "GET #destroy" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }
      it "redirects to root page" do
        delete :destroy, params: { id: new_user.id }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context 'admin' do
    before :each do
      admin = create :admin
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { admin }
      create :profile, user: admin
    end

    describe "GET #index" do
      it "shows users list" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      context 'with valid params' do
        subject do
          post :create, params: { user: { email: "#{Faker::Internet.user_name}@lohika.com", admin: false } }
        end

        it 'creates new user' do
          expect { subject }.to change { User.count }.by(1)
        end

        it 'redirects to users_path' do
          subject
          expect(response).to redirect_to(users_path)
        end

        it 'set a flash notice' do
          subject
          expect(controller).to set_flash[:notice].to('User was successfully created.')
        end
      end

      context 'with invalid params' do
        it "redirects to index page with flash" do
          post :create, params: { user: { email: "#{Faker::Internet.user_name}@notlohika.com", admin: false } }
          expect(response).to redirect_to(users_path)
          expect(controller).to set_flash[:alert]
        end
      end
    end

    describe "GET #edit" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }
      it "retrun http success" do
        get :edit, params: { id: new_user.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH #update" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }

      context 'with valid params' do
        subject do
          patch :update, params: { id: new_user.id, user: { admin: true } }
        end

        it 'updates user' do
          subject
          expect(new_user.reload.admin).to be_truthy
        end

        it 'return success status' do
          subject
          expect(response).to redirect_to(users_path)
        end

        it 'sets a flash notice' do
          subject
          expect(controller).to set_flash[:notice].to('User was successfully updated.')
        end
      end

      context 'with invalid params' do
        subject do
          patch :update, params: { id: new_user.id, user: { email: 'invalid-email' } }
        end

        it 'redirects to edit path' do
          subject
          expect(response).to have_http_status(:success)
          expect(controller).to set_flash[:alert]
        end
      end
    end

    describe "GET #destroy" do
      let!(:new_user) { create :user, email: "#{Faker::Internet.user_name}@lohika.com", admin: false }

      subject do
        delete :destroy, params: { id: new_user.id }
      end

      it "redirects to root page" do
        subject
        expect(response).to redirect_to(users_path)
      end

      it 'deletes user' do
        expect { subject }.to change { User.count }.by(-1)
      end
    end
  end
end
