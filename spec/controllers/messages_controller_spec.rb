require "rails_helper"

RSpec.describe MessagesController, type: :controller do
  let(:application) { create(:application) }
  let(:chat) { create(:chat, application: application) }
  let(:message) { create(:message, chat: chat) }
  before(:each) do
    # Index the test data in Elasticsearch
    Message.__elasticsearch__.refresh_index!
  end
  describe "GET #search" do
    it "returns an empty array if no messages match the query" do
      get :search, params: { application_token: application.token, chat_number: chat.number, query: "nonexistent" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end

    it "returns a 404 error if the chat number is invalid for the given application token" do
      get :search, params: { application_token: application.token, chat_number: "invalid", query: message.body }
      expect(response).to have_http_status(:not_found)
    end

    it "returns a 404 error if the application token is invalid" do
      get :search, params: { application_token: "invalid", chat_number: chat.number, query: message.body }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #index" do
    it "returns all messages for a given application token and chat number" do
      get :index, params: { application_token: application.token, chat_number: chat.number }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(chat.messages.count)
    end

    it "returns an empty array if the chat has no messages" do
      chat.messages.destroy_all
      get :index, params: { application_token: application.token, chat_number: chat.number }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end

    it "returns a 404 error if the chat number is invalid for the given application token" do
      get :index, params: { application_token: application.token, chat_number: "invalid" }
      expect(response).to have_http_status(:not_found)
    end

    it "returns a 404 error if the application token is invalid" do
      get :index, params: { application_token: "invalid", chat_number: chat.number }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "returns the current message count from Redis" do
      post :create, params: { application_token: application.token, chat_number: chat.number, body: "Hello" }
      expect(JSON.parse(response.body)["current_message_count"]).to eq(1)
    end
  end
end
