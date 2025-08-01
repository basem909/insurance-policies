# spec/controllers/policies_controller_spec.rb
require "rails_helper"

RSpec.describe PoliciesController, type: :controller do
  let(:admin)          { create(:user, :admin) }
  let(:operator)       { create(:user, :operator) }
  let(:client)         { create(:user, :client) }
  let!(:other_policy)  { create(:policy) }
  let!(:client_policy) { create(:policy, user: client) }

  describe "GET #index" do
    context "as admin" do
      before { sign_in admin }

      it "assigns all policies" do
        get :index
        expect(assigns(:policies)).to match_array([other_policy, client_policy])
      end
    end

    context "as operator" do
      before { sign_in operator }

      it "assigns all policies" do
        get :index
        expect(assigns(:policies)).to match_array([other_policy, client_policy])
      end
    end

    context "as client" do
      before { sign_in client }

      it "assigns only own policies" do
        get :index
        expect(assigns(:policies)).to eq([client_policy])
      end
    end
  end

  describe "GET #show" do
    context "as admin" do
      before { sign_in admin }

      it "shows any policy" do
        get :show, params: { id: other_policy.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "as client (own)" do
      before { sign_in client }

      it "shows own policy" do
        get :show, params: { id: client_policy.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "as client (unauthorized)" do
      before do
        sign_in client
        get :show, params: { id: other_policy.id }
      end

      it "redirects to root with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "GET #new" do
    context "as operator" do
      before { sign_in operator }

      it "renders new" do
        get :new
        expect(response).to have_http_status(:ok)
      end
    end

    context "as client" do
      before do
        sign_in client
        get :new
      end

      it "redirects to root with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        policy: {
          user_id:    client.id,
          start_date: Date.today,
          end_date:   1.month.from_now.to_date,
          status:     "pending"
        }
      }
    end

    context "as operator" do
      before { sign_in operator }

      it "creates a policy and redirects" do
        expect {
          post :create, params: valid_params
        }.to change(Policy, :count).by(1)
        expect(response).to redirect_to(policy_path(Policy.last))
      end
    end

    context "as client" do
      before do
        sign_in client
        post :create, params: valid_params
      end

      it "redirects to root with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "GET #edit" do
    context "as admin" do
      before { sign_in admin }

      it "renders edit" do
        get :edit, params: { id: client_policy.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "as operator" do
      before do
        sign_in operator
        get :edit, params: { id: client_policy.id }
      end

      it "redirects to root with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "PATCH #update" do
    let(:new_status) { "expired" }

    context "as admin" do
      before { sign_in admin }

      it "updates the policy and redirects" do
        patch :update, params: { id: client_policy.id, policy: { status: new_status } }
        expect(client_policy.reload.status).to eq(new_status)
        expect(response).to redirect_to(policy_path(client_policy))
      end
    end

    context "as operator" do
      before do
        sign_in operator
        patch :update, params: { id: client_policy.id, policy: { status: new_status } }
      end

      it "redirects to root with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end

  describe "DELETE #destroy" do
    context "as admin" do
      before { sign_in admin }

      it "destroys the policy and redirects to index" do
        expect {
          delete :destroy, params: { id: client_policy.id }
        }.to change(Policy, :count).by(-1)
        expect(response).to redirect_to(policies_path)
      end
    end

    context "as operator" do
      before do
        sign_in operator
        delete :destroy, params: { id: client_policy.id }
      end

      it "redirects to root with an alert" do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/not authorized/)
      end
    end
  end
end
