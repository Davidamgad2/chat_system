require "swagger_helper"

RSpec.describe "API", type: :request do
  let!(:application) { create(:application) }
  let!(:chat) { create(:chat, application: application) }
  let!(:message) { create(:message, chat: chat) }

  path "/applications" do
    get "Retrieves all applications" do
      tags "Applications"
      produces "application/json"

      response "200", "applications found" do
        run_test!
      end
    end

    post "Creates a new application" do
      tags "Applications"
      consumes "application/json"
      parameter name: :application_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ["name"],
      }

      response "201", "application created" do
        let(:application_params) { { name: "Test App" } }
        run_test!
      end
    end
  end

  path "/applications/{token}" do
    get "Retrieves a specific application" do
      tags "Applications"
      produces "application/json"
      parameter name: :token, in: :path, type: :string

      response "200", "application found" do
        let(:token) { application.token }
        run_test!
      end

      response "404", "application not found" do
        let(:token) { "invalid" }
        run_test!
      end
    end

    patch "Updates an application name" do
      tags "Applications"
      consumes "application/json"
      parameter name: :token, in: :path, type: :string
      parameter name: :application_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
        },
        required: ["name"],
      }

      response "200", "application updated" do
        let(:token) { application.token }
        let(:application_params) { { name: "Updated App Name" } }
        run_test!
      end

      response "422", "unprocessable entity" do
        let(:token) { application.token }
        let(:application_params) { { name: "" } }
        run_test!
      end
    end
  end

  path "/applications/{application_token}/chats" do
    get "Retrieves all chats for an application" do
      tags "Chats"
      produces "application/json"
      parameter name: :application_token, in: :path, type: :string

      response "200", "chats found" do
        let(:application_token) { application.token }
        run_test!
      end
    end

    post "Creates a new chat for an application" do
      tags "Chats"
      consumes "application/json"
      parameter name: :application_token, in: :path, type: :string

      response "201", "chat created" do
        let(:application_token) { application.token }
        run_test!
      end
    end
  end

  path "/applications/{application_token}/chats/{chat_number}" do
    get "Retrieves a specific chat" do
      tags "Chats"
      produces "application/json"
      parameter name: :application_token, in: :path, type: :string
      parameter name: :chat_number, in: :path, type: :string

      response "200", "chat found" do
        let(:application_token) { application.token }
        let(:chat_number) { chat.number }
        run_test!
      end

      response "404", "chat not found" do
        let(:application_token) { application.token }
        let(:chat_number) { "invalid" }
        run_test!
      end
    end
  end

  path "/applications/{application_token}/chats/{chat_number}/messages" do
    get "Retrieves all messages for a chat" do
      tags "Messages"
      produces "application/json"
      parameter name: :application_token, in: :path, type: :string
      parameter name: :chat_number, in: :path, type: :string

      response "200", "messages found" do
        let(:application_token) { application.token }
        let(:chat_number) { chat.number }
        run_test!
      end
    end

    post "Creates a new message for a chat" do
      tags "Messages"
      consumes "application/json"
      parameter name: :application_token, in: :path, type: :string
      parameter name: :chat_number, in: :path, type: :string
      parameter name: :message_params, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string },
        },
        required: ["body"],
      }

      response "201", "message created" do
        let(:application_token) { application.token }
        let(:chat_number) { chat.number }
        let(:message_params) { { body: "Hello, world!" } }
        run_test!
      end
    end
  end

  path "/applications/{application_token}/chats/{chat_number}/messages/search" do
    get "Searches messages in a chat" do
      tags "Messages"
      produces "application/json"
      parameter name: :application_token, in: :path, type: :string
      parameter name: :chat_number, in: :path, type: :string
      parameter name: :query, in: :query, type: :string

      response "200", "messages found" do
        let(:application_token) { application.token }
        let(:chat_number) { chat.number }
        let(:query) { "search term" }
        run_test!
      end

      response "404", "chat not found" do
        let(:application_token) { application.token }
        let(:chat_number) { "invalid" }
        let(:query) { "search term" }
        run_test!
      end
    end
  end
end
