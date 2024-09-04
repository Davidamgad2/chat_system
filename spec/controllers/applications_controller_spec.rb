require "rails_helper"

RSpec.describe ApplicationsController, type: :controller do
  let(:application) { create(:application) }

  describe "POST #create" do
    it "creates a new application with a valid name" do
      expect {
        post :create, params: { application: { name: "Test App" } }
      }.to change(Application, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns a 422 error if the name is missing or invalid" do
      post :create, params: { application: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #index" do
    it "returns all applications" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Application.count)
    end
  end

  describe "GET #show" do
    it "returns the application for a given token" do
      get :show, params: { token: application.token }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["token"]).to eq(application.token)
    end

    it "returns a 404 error if the token is invalid" do
      get :show, params: { token: "invalid" }
      expect(response).to have_http_status(:not_found)
    end
  end
end
