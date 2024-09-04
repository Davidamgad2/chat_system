require "rails_helper"

RSpec.describe ChatsController, type: :controller do
  let(:application) { create(:application) }
  let(:chat) { create(:chat, application: application) }

  describe "GET #index" do
    it "returns all chats for a given application token" do
      get :index, params: { application_token: application.token }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(application.chats.count)
    end

    it "returns an empty array if the application has no chats" do
      application.chats.destroy_all
      get :index, params: { application_token: application.token }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end
  end

  describe "GET #show" do
    it "returns the chat for a given application token and chat number" do
      get :show, params: { application_token: application.token, number: chat.number }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["number"]).to eq(chat.number)
    end

    it "returns a 404 error if the chat number is invalid for the given application token" do
      get :show, params: { application_token: application.token, number: "invalid" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "returns the current chat count from Redis" do
      post :create, params: { application_token: application.token }
      puts response.body
      expect(JSON.parse(response.body)["current_message_count"]).to eq(1)
    end
  end
end
