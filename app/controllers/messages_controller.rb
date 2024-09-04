class MessagesController < ApplicationController
  def search
    application = Application.find_by(token: params[:application_token])
    chat = Chat.find_by(number: params[:chat_number], application_id: application&.id)

    if chat
      @messages = Message.search({
        query: {
          bool: {
            must: [
              { wildcard: { body: "*#{params[:query]}*" } },
              { term: { chat_id: chat.id } },
            ],
          },
        },
      }).records

      render json: @messages
    else
      render json: { error: "Chat not found" }, status: :not_found
    end
  end

  def index
    application = Application.find_by(token: params[:application_token])
    @chat = Chat.find_by(number: params[:chat_number], application_id: application&.id)
    if @chat
      @messages = @chat.messages
      render json: @messages
    else
      render json: { error: "Chat not found" }, status: :not_found
    end
  end

  def create
    chat_number = params[:chat_number]
    application_token = params[:application_token]
    message_body = params[:body]

    application = Application.find_by(token: application_token)
    chat = Chat.find_by(number: chat_number, application_id: application&.id)
    chat_key = "chat:#{application_token}#{chat.id}:messages_count"

    # Fetch the current message count from Redis
    current_message_count = $redis.get(chat_key).to_i + 1
    message_number = $redis.incr(chat_key)

    # Enqueue the job to create the message
    CreateMessageWorker.perform_async(application.id, chat.id, chat.number, message_body, message_number)

    render json: { current_message_count: current_message_count }, status: :created
  end
end
