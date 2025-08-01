# spec/requests/policies_spec.rb
require "rails_helper"

RSpec.describe "Policies", type: :request do
  let(:admin)    { create(:user, :admin) }
  let(:operator) { create(:user, :operator) }
  let(:client)   { create(:user, :client) }
  let!(:client_policy) { create(:policy, user: client) }

  describe "GET /policies" do
    context "as admin" do
      before { sign_in admin }

      it "renders the index with all policies" do
        get policies_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(client_policy.policy_number)
      end
    end

    context "as client" do
      before { sign_in client }

      it "only shows own policies" do
        other = create(:policy)
        get policies_path
        expect(response.body).to include(client_policy.policy_number)
        expect(response.body).not_to include(other.policy_number)
      end
    end
  end

  describe "GET /policies/:id" do
    context "authorized" do
      before { sign_in client }
      it "shows own policy" do
        get policy_path(client_policy)
        expect(response).to have_http_status(:ok)
      end
    end

    context "unauthorized" do
      before { sign_in client }
      it "redirects or forbids access to others' policies" do
        other = create(:policy)
        get policy_path(other)
        # depending on your rescue_from, could be redirect or 403:
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end
  end

  describe "POST /policies" do
    let(:params) do
      { policy: {
          user_id: client.id,
          start_date: Date.today,
          end_date: 1.month.from_now.to_date,
          status: "pending"
        }
      }
    end

    context "as operator" do
      before { sign_in operator }
      it "creates a new policy and redirects" do
        expect {
          post policies_path, params: params
        }.to change(Policy, :count).by(1)
        expect(response).to redirect_to(policy_path(Policy.last))
      end
    end

    context "as client" do
      before { sign_in client }
      it "is forbidden" do
        post policies_path, params: params
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end
  end

  describe "PATCH /policies/:id" do
    let(:new_status) { "expired" }
    before { sign_in admin }

    it "updates the policy and redirects" do
      patch policy_path(client_policy), params: { policy: { status: new_status } }
      expect(client_policy.reload.status).to eq(new_status)
      expect(response).to redirect_to(policy_path(client_policy))
    end
  end

  describe "DELETE /policies/:id" do
    before { sign_in admin }

    it "destroys the policy and redirects" do
      expect {
        delete policy_path(client_policy)
      }.to change(Policy, :count).by(-1)
      expect(response).to redirect_to(policies_path)
    end
  end
end
